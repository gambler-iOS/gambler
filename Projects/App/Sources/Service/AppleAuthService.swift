//
//  AppleAuthService.swift
//  gambler
//
//  Created by 박성훈 on 3/2/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import AuthenticationServices
import CryptoKit

final class AppleAuthService {
    /// AppleSignInManager shared instance.
    static let shared = AppleAuthService()

    /// Un-hashed nonce.
    fileprivate static var currentNonce: String?

    /// Current un-hashed nonce
    static var nonce: String? {
        currentNonce ?? nil
    }

    private init() {}

    func requestAppleAuthorization(_ request: ASAuthorizationAppleIDRequest) {
        AppleAuthService.currentNonce = randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(AppleAuthService.currentNonce!)
    }

    func signOut() {
        // TODO: Revoke Apple ID
    }
}

extension AppleAuthService {
    /// Generate a random string -a cryptographically secure "nonce"- which will be used to make sure the ID token was granted specifically in response to the app's authentication request.
    /// - parameter length: integer
    /// - returns: string containing a cryptographically secure "nonce"
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

    /// Secure Hashing Algorithm 2 (SHA-2) hashing with a 256-bit digest
    /// - parameter input: String containing nonce.
    /// - returns: String containing hash value of nonce.
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
