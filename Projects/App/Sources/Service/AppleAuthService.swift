//
//  AppleAuthService.swift
//  gambler
//
//  Created by 박성훈 on 3/5/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import Alamofire
import SwiftJWT

/// 앱에서 Apple 흐름으로 로그인을 승인하고 nonce를 생성
final class AppleAuthService {
    
    static let shared = AppleAuthService()
    
    /// Un-hashed nonce.
    fileprivate static var currentNonce: String?
    private let keyID = Bundle.main.infoDictionary?["Key_ID"] ?? ""
    private let teamID = Bundle.main.infoDictionary?["Team_ID"] ?? ""
    private let bundleID = Bundle.main.bundleIdentifier ?? ""
    
    /// Current un-hashed nonce
    static var nonce: String? {
        currentNonce ?? nil
    }
    
    private init() { }
    
    func requestAppleAuthorization(_ request: ASAuthorizationAppleIDRequest) {
        Self.currentNonce = randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(Self.currentNonce ?? "")
    }
    
    func signOutFromApple() async {
        // TODO: Revoke Apple ID
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension AppleAuthService {
    /// 암호화적으로 안전한 "nonce"인 임의의 문자열을 생성하여 앱의 인증 요청에 대한 응답으로 ID 토큰이 특별히 부여되었는지 확인하는 데 사용
    /// - parameter length: integer
    /// - returns: 암호학적으로 안전한 "nonce"가 포함된 문자열
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    /// original nonce를 256비트 다이제스트로 안전하게 해싱하면 이 논스의 SHA256 해시값이 Apple 로그인 요청으로 전송됩니다.
    /// - parameter input: nonce가 포함된 문자열
    /// - returns: nonce의 해시값이 포함된 문자열
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // TODO: Cloud Functions 통해서 토큰 revoke
    func deRegister() async {
        // Firebase에서 user.delete만 해주면 되는게 아님.
        // revokeToken + firebase 회원탈퇴 두개 다 진행해줘야 한다.
        // JWT를 생성하고 Apple ID를 사용하는 앱 항목에서 내 앱을 삭제하기 위해서는 이 api를 처리할 서버로직이 필요하다
        // Firebase의 Cloud Functions를 사용하면 백엔드 로직을 간단하게 구현
        
        // https://weekoding.tistory.com/29 참고
        // swift jwt를 발급 받고, store에 저장하고 있다가, 탈퇴할 떄 jwt랑 토큰 활용
        
        let jwtString = self.makeJWT()
        
        guard let taCode = UserDefaults.standard.string(forKey: "theAuthorizationCode") else { return }
        
        self.getAppleRefreshToken(code: taCode, completionHandler: { output in
            let clientSecret = jwtString
            
            if let refreshToken = output{
                print("Client_Secret - \(clientSecret)")
                print("refresh_token - \(refreshToken)")
                
                // api 통신
                self.revokeAppleToken(clientSecret: clientSecret, token: refreshToken) {
                    print("Apple revoke token Success")
                }
            } else{
                print(#fileID, #function, #line, "- 회원탈퇴 실패 ")
            }
        })
        
        
    }
}

// MARK: - Generate and validate token & revoke JWT
extension AppleAuthService {
    
    /// client_secret 생성
    func makeJWT() -> String {
        let myHeader = Header(kid: "\(keyID)")  // Apple_Key_ID
        
        let nowDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = 6
        let sixDate = Calendar.current.date(byAdding: dateComponent, to: nowDate) ?? Date()
        let iat = Int(Date().timeIntervalSince1970)
        let exp = iat + 2600
        let bundleID = Bundle.main.bundleIdentifier ?? ""
        let myClaims = MyClaims(iss: "\(teamID)",
                                iat: iat,
                                exp: exp,
                                aud: "https://appleid.apple.com",
                                sub: bundleID)
        
        var myJWT = JWT(header: myHeader, claims: myClaims)
        
        // JWT 발급을 요청값의 암호화 과정에서 다운받아두었던 Key File이 필요(.p8 파일)
        guard let url = Bundle.main.url(forResource: "AuthKey_5V6V6SJZB5", withExtension: "p8") else {
            return ""
        }
        
        guard let privateKey: Data = try? Data(contentsOf: url, options: .alwaysMapped) else {
            print(#fileID, #function, #line, "- privateKey 없음 ")
            return ""
        }
        
        let jwtSinger = JWTSigner.es256(privateKey: privateKey)
        
        guard let signedJWT = try? myJWT.sign(using: jwtSinger) else {
            print(#fileID, #function, #line, "- JWT X ")
            return ""
        }
        
        print("🗝 singedJWT - \(signedJWT)")
        return signedJWT
    }
    
    //client_refreshToken
    func getAppleRefreshToken(code: String, completionHandler: @escaping (String?) -> Void) {
        guard let secret = UserDefaults.standard.string(forKey: "AppleClientSecret") else { return }
        
        let url = "https://appleid.apple.com/auth/token?client_id=\(self.bundleID)&client_secret=\(secret)&code=\(code)&grant_type=authorization_code"
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        
        print("🗝 clientSecret - \(String(describing: UserDefaults.standard.string(forKey: "AppleClientSecret")))")
        print("🗝 authCode - \(code)")
        
        // Alamofire
        let a = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseData { response in
                print("🗝 response - \(response.description)")
                
                switch response.result {
                case .success(let output):
                    print("🗝 ouput - \(output)")
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(AppleTokenResponse.self, from: output){
                        print("🗝 output2 - \(String(describing: decodedData.refresh_token))")
                        
                        if decodedData.refresh_token == nil{
                            print(#fileID, #function, #line, "- 토큰 생성 실패 ")
                        }else{
                            completionHandler(decodedData.refresh_token)
                        }
                    }
                case .failure(_):
                    //로그아웃 후 재로그인하여
                    print("애플 토큰 발급 실패 - \(response.error.debugDescription)")
                }
            }
    }
    
    
    
    // MARK: - 애플 토큰 삭제 (탈퇴) HTTP 통신
    // Alamofire 라이브러리 사용
    func revokeAppleToken(clientSecret: String, token: String, completionHandler: @escaping () -> Void) {
        let url = "https://appleid.apple.com/auth/revoke?client_id=\(self.bundleID)&client_secret=\(clientSecret)&token=\(token)&token_type_hint=refresh_token"
        
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        
        AF.request(url,
                   method: .post,
                   headers: header)
        .validate(statusCode: 200..<600)
        .responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            if statusCode == 200 {
                print("애플 토큰 삭제 성공!")
                completionHandler()
            }
        }
    }
    
}

// MARK: - client_secret(JWT) 발급 응답 모델
fileprivate struct MyClaims: Claims {
    let iss: String
    let iat: Int
    let exp: Int
    let aud: String
    let sub: String
}

// MARK: - 애플 엑세스 토큰 발급 응답 모델
fileprivate struct AppleTokenResponse: Codable {
    var access_token: String?
    var token_type: String?
    var expires_in: Int?
    var refresh_token: String?
    var id_token: String?
    
    enum CodingKeys: String, CodingKey {
        case refresh_token = "refresh_token"
    }
}


// 유튭 보고 따라하는 revoke jwt
extension AppleAuthService {
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString2()
        Self.currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            print(#fileID, #function, #line, "- \(failure.localizedDescription)")
        }
        else if case .success(let authorization) = result {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = Self.currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetdch identify token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                               rawNonce: nonce,
                                                               fullName: appleIDCredential.fullName)
                
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        await AuthService.shared.setTempUser(id: result.user.uid,
                                                             nickname: result.user.displayName ?? "known",
                                                             profileImage: result.user.photoURL?.absoluteString ?? "",
                                                             apnsToken: "애플",
                                                             loginPlatform: .apple)
                        
                        print(#fileID, #function, #line, "- tempUSer ")
                        dump(AuthService.shared.tempUser)
                        
                    }
                    catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func randomNonceString2(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
}

extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap( {$0})
            .joined(separator: " ")
    }
}

final class SignInWithApple: NSObject, ASAuthorizationControllerDelegate {
    
    private var continuation : CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?
    
    func callAsFunction() async throws -> ASAuthorizationAppleIDCredential {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
            continuation?.resume(returning: appleIDCredential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
    }
}

final class TokenRevocationHelper: NSObject, ASAuthorizationControllerDelegate {
    
    private var continuation : CheckedContinuation<Void, Error>?
    
    func revokeToken() async throws {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
            guard let authorizationCode = appleIDCredential.authorizationCode else { return }
            guard let authCodeString = String(data: authorizationCode, encoding: .utf8) else { return }
            
            Task {
                try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                continuation?.resume()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
    }
}
