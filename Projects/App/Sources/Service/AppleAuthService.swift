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

/// 앱에서 Apple 흐름으로 로그인을 승인하고 nonce를 생성
final class AppleAuthService {
    
    static let shared = AppleAuthService()
    
    /// Un-hashed nonce.
    fileprivate static var currentNonce: String?
    /// Current un-hashed nonce
    static var nonce: String? {
        currentNonce ?? nil
    }
    
    private init() { }
    
    func verifySignInWithAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                do {
                    let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                    switch credentialState {
                    case .authorized:
                        break // The Apple ID credential is valid.
                    case .revoked, .notFound:
                        // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                        await AuthService.shared.signOut()
                        //                        AppleAuthService.shared.signOutFromApple()
                    default:
                        break
                    }
                }
                catch {
                    print("FirebaseAuthError: signOut() failed. \(error)")
                }
            }
        }
    }
    
    /// 암호화적으로 안전한 "nonce"인 임의의 문자열을 생성하여 앱의 인증 요청에 대한 응답으로 ID 토큰이 특별히 부여되었는지 확인하는 데 사용
    /// - Parameter length: 32글자를 기본으로 함
    /// - Returns: 암호학적으로 안전한 "nonce"가 포함된 문자열
    func randomNonceString(length: Int = 32) -> String {
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
}

extension AppleAuthService {
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
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
                        
                        let userName: String = appleIDCredential.displayName()
                        await AuthService.shared.setTempUser(id: result.user.uid,
                                                             nickname: userName,
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
    
    func deleteAppleAccount() async {
        guard let user = Auth.auth().currentUser else {
            print("현재 로그인 유저 없음")
            return
        }
        guard let lastSignInDate = user.metadata.lastSignInDate else { return }
        let needsReauth = !lastSignInDate.isWithinPast(minutes: 5)  // 지난 5분동안 로그인했는지 확인
        let needsTokenRevocation = user.providerData.contains { $0.providerID == "apple.com" }
        
        do {
            // 재인증 흐름을 위해 사용자에게 재로그인하도록 요청하는 코드
            if needsReauth || needsTokenRevocation {
                let signInWithApple = SignInWithApple()
                let appleIDCredential = try await signInWithApple()
                
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetdch identify token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                // 사용자가 로그인하면 공급자로부터 반환된 정보를 사용하여 새로운 credential을 만듦
                let nonce = AppleAuthService.shared.randomNonceString()
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                
                if needsReauth {  // 사용자가 제공한 자격 증명으로, 서버에서 유효성을 검사
                    try await user.reauthenticate(with: credential)
                }
                if needsTokenRevocation {
                    guard let authorizationCode = appleIDCredential.authorizationCode else { return }
                    guard let authCodeString = String(data: authorizationCode, encoding: .utf8) else { return }
                    
                    // 사용자가 다시 로그인하면, 인증 코드를 사용하여 auth.revokeToken을 호출할 수 있음
                    // Firebase는 사용자와 연결된 acess Token을 검색한 다음 Apple의 revokeToken endpoint를 호출하여 토큰을 취소
                    try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                    print("revokeToken 성공")
                }
            }
            
            try await user.delete()  // user.delete를 비동기식으로 호출
        } catch {  // 오류 처리 코드
            print(#fileID, #function, #line, "- \(error.localizedDescription)")
        }
    }

}

// MARK: - User 이름을 반환하기 위해
extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap({$0})
            .joined()
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
