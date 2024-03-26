//
//  File.swift
//  gambler
//
//  Created by 박성훈 on 3/4/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var userSession: FirebaseAuth.User?
    @Published var authState = AuthState.signedOut
    
    // 이 리스너는 사용자의 로그인 상태가 바뀔 때마다 호출됨
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    
    init() {
        // 3. 인증 변경사항 수신
        configureAuthStateChanges()
        
        AppleAuthService.shared.verifySignInWithAppleID()
    }
    
    // MARK: - Auth State
    /// 권한 부여 상태 변경에 대한 리스너를 추가
    func configureAuthStateChanges() {
        // Listner = 인증이자 사용자
        authStateHandle = Auth.auth().addStateDidChangeListener { _, user in
            print("Auth changed: \(user != nil)")
            print("configureAuthStateChanges - \(self.authState)")
            
            guard user != nil else {
                // 유효한 사용자가 없기 때문에 로그인되지 않았음을 의미
                print("User is nil")
                self.authState = .signedOut
                self.currentUser = nil
                return
            }
            
            Task {
                await self.fetchUserData()
                AuthService.shared.isLoading = false
            }
        }
    }
    
    /// 권한 부여 상태의 변경 사항에 대한 리스너를 제거
    func removeAuthStateListener() {
        Auth.auth().removeStateDidChangeListener(authStateHandle)
    }
    
    func resetAuth() {
        self.authState = .signedOut
        self.currentUser = nil
        self.userSession = nil
        AuthService.shared.tempUser = nil
    }
    
    // MARK: - 현재 유저 데이터 가져오기 - Firebasestore
    @MainActor
    func getUserDate() async {
        Task {
            do {
                guard let user: User = try await FirebaseManager.shared.fetchOneData(collectionName: "Users", byId: currentUser?.id ?? "") else { return }
                self.currentUser = user
            } catch {
                print(#fileID, #function, #line, "- 유저 정보 가져오기 실패!")
            }
        } 
    }
    
    /// 유저 정보 가져오기 및 authState 변경
    func fetchUserData() async {
        self.userSession = Auth.auth().currentUser
        print("Auth.currentUser: \(String(describing: self.userSession))")
        
        guard let currentUid = userSession?.uid else {
            print("로그인된 유저 없음")
            self.authState = .signedOut
            return
        }
        print("UID = \(currentUid)")
        
        do {
            guard let user: User = try await FirebaseManager.shared.fetchOneData(collectionName: "Users", byId: currentUid) else {
                self.authState = .creatingAccount
                return
            }
            self.authState = .signedIn
            self.currentUser = user
        } catch {
            print("Error fetching LoginViewModel : \(error.localizedDescription)")
        }
    }
    
    /// 로그아웃 - 연결된 소셜도 연결 취소
    func logoutFromFirebaseAndSocial() async {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        Task {
            for profile in user.providerData {
                switch profile.providerID {
                case "password":
                    await AuthService.shared.signOut()
                    await KakaoAuthService.shared.handleKakaoLogout()
                case "apple.com":
                    await AuthService.shared.signOut()
                case "google.com":
                    await AuthService.shared.signOut()
                    await GoogleAuthSerVice.shared.signOutFromGoogle()
                default:
                    print("다른 방법으로 로그인함")
                }
            }
            self.resetAuth()
        }
    }
    
    /// Firebase Auth 삭제 및 Firestore 데이터 삭제
    private func deleteAccount() async -> Bool {
        
        guard let user = Auth.auth().currentUser else { return false }
        var success = false
        
        for profile in user.providerData {
            switch profile.providerID {
            case "apple.com":
                success = await AppleAuthService.shared.deleteAppleAccount()
            case "google.com":
                success = await GoogleAuthSerVice.shared.deleteGoogleAccount()
            case "password":
                success = await KakaoAuthService.shared.deleteKakaoAccount()
            default:
                success = false
            }
            
            if success {
                return true
            }
        }
        return success
    }
    
    /// 계정 삭제 후 성공하면 AuthData 리셋
    /// - Returns: Bool - 계정 삭제 성공 여부
    func deleteAndResetAuth() async -> Bool {
        let success = await deleteAccount()
        
        if success {
            self.resetAuth()
        }
        return success
    }
}
