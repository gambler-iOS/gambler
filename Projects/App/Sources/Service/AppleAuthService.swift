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
    
    func requestAppleAuthorization(_ request: ASAuthorizationAppleIDRequest) {
        Self.currentNonce = randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(Self.currentNonce ?? "")
    }
    
    func signOutFromApple() {
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
    private func randomNonceString(length: Int = 32) -> String {
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
    func revokeToken() async {
        // Firebase에서 user.delete만 해주면 되는게 아님.
        // revokeToken + firebase 회원탈퇴 두개 다 진행해줘야 한다.
        // JWT를 생성하고 Apple ID를 사용하는 앱 항목에서 내 앱을 삭제하기 위해서는 이 api를 처리할 서버로직이 필요하다
        // Firebase의 Cloud Functions를 사용하면 백엔드 로직을 간단하게 구현
    }
}
