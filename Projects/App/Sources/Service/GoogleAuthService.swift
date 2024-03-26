//
//  GoogleAuthService.swift
//  gambler
//
//  Created by 박성훈 on 3/4/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

@MainActor
final class GoogleAuthSerVice {
    static let shared = GoogleAuthSerVice()
    
    typealias GoogleAuthResult = (GIDGoogleUser?, Error?) -> Void
    
    private init() { }
    
    /// 구글 로그인
    func signInWithGoogle() async {
        await GoogleAuthSerVice.shared.signInWithGoogle { user, error in
            if let error {
                print("GoogleSignInError: failed to sign in with Google, \(error))")
            }
            AuthService.shared.isLoading = true
            guard let gidUser = user else { return }
            Task {
                do {
                    let result = try await GoogleAuthSerVice.shared.authenticateGoogle(gidUser)
                    if let result {
                        print("GoogleSignInSuccess: \(result.user.uid)")
                        let user = result.user  // firebase Auth의 User
                        
                        // 회원가입때 쓸 수 있으니 dummy에 저장함
                        await AuthService.shared.setTempUser(id: user.uid,
                                                             nickname: user.displayName ?? "닉네임",
                                                             profileImage: user.photoURL?.absoluteString ?? "",
                                                             apnsToken: nil,
                                                             loginPlatform: .google)
                    }
                } catch {
                    print("GoogleSignInError: failed to authenticate with Google, \(error))")
                }
            }
        }
    }
    
    /// Sign in with `Google`.
    /// - Parameter completion: restore/sign-in 흐름이 완료되면 호출되는 블록
    private func signInWithGoogle(_ completion: @escaping GoogleAuthResult) async {
        // 1. 이전 로그인 확인
        if GIDSignIn.sharedInstance.hasPreviousSignIn() { // 이 전에 로그인 - 사용자의 로그인 복원
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                completion(user, error)
            }
        } else {  // 로그인 뷰로 이동
            // 2. UIApplication의 공유 인스턴스를 통해 루트 뷰 컨트롤러에 액세스
            // Google Sign-In SDK는 rootViewController를 사용하여 로그인 흐름을 호스팅하는 브라우저 팝업을 제공
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            // 3. Start sign-in flow
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                completion(result?.user, error)
            }
        }
    }
    
    /// Sign out from `Google`.
    func signOutFromGoogle() async {
        Task {
            GIDSignIn.sharedInstance.signOut()
        }
    }
    
    func deleteGoogleAccount() async -> Bool {
        await withCheckedContinuation { continuation in
            Task {
                do {
                    guard let user = Auth.auth().currentUser else {
                        continuation.resume(returning: false)
                        return
                    }
                    
                    try Auth.auth().signOut()
                    await self.signOutFromGoogle()
                    
                    user.delete() { error in
                        Task {
                            if let error = error {
                                print(#fileID, #function, #line, "- \(error.localizedDescription) ")
                                continuation.resume(returning: false)
                            } else {
                                try await FirebaseManager.shared.deleteData(collectionName: "Users", byId: user.uid)
                                continuation.resume(returning: true)
                            }
                        }
                    }
                } catch let error as NSError {
                    print(#fileID, #function, #line, "- Error signing out Google:  \(error.localizedDescription) ")
                    
                }
            }
        }
    }
    
    /// Google `idToken` 과 `GIDGoogleUser`의 `accessToken`을 사용하여 Firebase 인증
    /// - Parameter user: 로그인한 Google 사용자
    /// - Returns: Auth data.
    func authenticateGoogle(_ user: GIDGoogleUser) async throws -> AuthDataResult? {
        guard let idToken = user.idToken?.tokenString else { return nil }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        
        do {
            return try await googleAuthSignIn(credentials: credentials)
        } catch {
            print("FirebaseAuthError: googleAuth(user:) failed. \(error)")
            throw error
        }
    }
    
    // MARK: - Sign-in
    private func googleAuthSignIn(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            let result = try await Auth.auth().signIn(with: credentials)
            //            updateState(user: result.user)
            return result
        } catch {
            print("FirebaseAuthError: signIn(with:) failed. \(error)")
            throw error
        }
    }
}
