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
    
    // 1. 이 리스너는 사용자의 로그인 상태가 바뀔 때마다 호출됨
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    
    /// Common auth link errors.
    private let authLinkErrors: [AuthErrorCode.Code] = [
        .emailAlreadyInUse,
        .credentialAlreadyInUse,
        .providerAlreadyLinked
    ]
    
    init() {
        // 3. 인증 변경사항 수신
        configureAuthStateChanges()
        
        // Check AppleID credentials
        verifySignInWithAppleID()
    }
    
    // MARK: - Auth State
    /// 권한 부여 상태 변경에 대한 리스너를 추가
    func configureAuthStateChanges() {
        // Listner = 인증이자 사용자
        authStateHandle = Auth.auth().addStateDidChangeListener { _, user in
            print("Auth changed: \(user != nil)")
            print("configureAuthStateChanges - \(self.authState)")
            
            guard let user else {
                // 유효한 사용자가 없기 때문에 로그인되지 않았음을 의미
                print("User is nil")
                self.authState = .signedOut
                self.currentUser = nil
                return
            }
            
            Task {
                await self.fetchUserData()
                
                //                if self.currentUser != nil {
                //                    self.removeAuthStateListener()
                //                }
            }
        }
    }
    /// 권한 부여 상태의 변경 사항에 대한 리스너를 제거
    func removeAuthStateListener() {
        Auth.auth().removeStateDidChangeListener(authStateHandle)
    }
    
    /// Update auth state for given user.
    /// - Parameter user: `Optional` firebase user.
    func updateState(user: FirebaseAuth.User?) async {
        self.userSession = user
        let isAuthenticatedUser = user != nil
        
        guard isAuthenticatedUser else {
            self.authState = .signedOut
            self.currentUser = nil
            self.userSession = nil
            return
        }
        
        Task {
            guard let currentUser: User = try await FirebaseManager.shared.fetchOneData(collectionName: "Users", byId: self.userSession?.uid ?? "") else {
                self.authState = .creatingAccount
                return
            }
            self.authState = .signedIn
            await self.fetchUserData()
        }
    }
    
    func resetAuth() {
        self.authState = .signedOut
        self.currentUser = nil
        self.userSession = nil
        AuthService.shared.tempUser = nil  // temp유저도 리셋인데
        
        print("userSession - \(self.userSession)")
        print("currentUser - \(self.currentUser)")
        print("tempUser - \(AuthService.shared.tempUser)")
        
    }
    
    func verifySignInWithAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                switch credentialState {
                case .authorized:
                    break // The Apple ID credential is valid.
                case .revoked, .notFound:
                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                    do {
                        try await self.signOut()
                        //                        AppleAuthService.shared.signOutFromApple()
                    } catch {
                        print("FirebaseAuthError: signOut() failed. \(error)")
                    }
                default:
                    break
                }
            }
        }
    }
    
    //MARK: - Authenticate
    private func authenticateUser(credentials: AuthCredential) async throws -> AuthDataResult? {
        // AuthCredential을 받고 인증된 사용자가 있는지 확인
        if Auth.auth().currentUser != nil {  // 인증된 사용자가 있는 경우 주어진 credentials으로 연결
            return try await authLink(credentials: credentials)
        } else {  // 주어진 자격 증명을 사용하여 로그인합니다.
            return try await authSignIn(credentials: credentials)
        }
    }
    
    /// Google `idToken` 과 `GIDGoogleUser`의 `accessToken`을 사용하여 Firebase 인증
    /// - Parameter user: 로그인한 Google 사용자
    /// - Returns: Auth data.
    func googleAuth(_ user: GIDGoogleUser) async throws -> AuthDataResult? {
        guard let idToken = user.idToken?.tokenString else { return nil }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        do {
            return try await authenticateUser(credentials: credentials)
        } catch {
            print("FirebaseAuthError: googleAuth(user:) failed. \(error)")
            throw error
        }
    }
    
    func appleAuth(
        _ appleIDCredential: ASAuthorizationAppleIDCredential,
        nonce: String?
    ) async throws -> AuthDataResult? {
        guard let nonce = nonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return nil
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return nil
        }
        
        // 사용자의 이름을 포함하여 Firebase 자격 증명을 초기화
        let credentials = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                        rawNonce: nonce,
                                                        fullName: appleIDCredential.fullName)
        
        do {
            return try await authenticateUser(credentials: credentials)
        } catch {
            print("FirebaseAuthError: appleAuth(appleIDCredential:nonce:) failed. \(error)")
            throw error
        }
    }
    
    // MARK: - Sign-in
    private func authSignIn(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            let result = try await Auth.auth().signIn(with: credentials)
            //            updateState(user: result.user)
            return result
        } catch {
            print("FirebaseAuthError: signIn(with:) failed. \(error)")
            throw error
        }
    }
    
    private func authLink(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            guard let user = Auth.auth().currentUser else { return nil }
            let result = try await user.link(with: credentials)
            return result
        } catch {
            print("FirebaseAuthError: link(with:) failed, \(error)")
            if let error = error as NSError? {
                if let code = AuthErrorCode.Code(rawValue: error.code),
                   authLinkErrors.contains(code) {
                    
                    let appleCredentials =
                    credentials.provider == "apple.com"
                    ? error.userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? AuthCredential
                    : nil
                    
                    return try await self.authSignIn(credentials: appleCredentials ?? credentials)
                }
            }
            throw error
        }
    }
    
    // MARK: - FireStore
    // 유저 정보 가져오기
    func fetchUserData() async {
        /* 문제상황 - 구글 로그아웃 후 애플 회원가입
         1. 회원가입으로 넘어가지 않고, 아이디끼리 링크가 되는 것
         */
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
                print("파이어스토어에 유저 정보 없음 -> 회원가입해야징")
                self.authState = .creatingAccount
                print("회원가입하려면 AuthState: \(authState)")
                return
            }
            self.authState = .signedIn
            print("로그인 상태::: \(authState)")
            self.currentUser = user
            dump(currentUser)
        } catch {
            print("Error fetching LoginViewModel : \(error.localizedDescription)")
        }
    }
    
    /// 각 플랫폼 별 로그아웃 - 로그인되어있는 유저의 loginPlatform으로 분기
    func firebaseProviderSignOut() async {
        let platform = currentUser?.loginPlatform
        
        switch platform {
        case .apple:
            Task {
                await AppleAuthService.shared.signOutFromApple()
                print("AuthState - 로그아웃 \(self.authState)")
            }
            
        case .google:
            Task {
                await GoogleAuthSerVice.shared.signOutFromGoogle()
                print("AuthState - 로그아웃 \(self.authState)")
            }
        case .kakakotalk:
            Task {
                try Auth.auth().signOut()
                await KakaoAuthService.shared.handleKakaoLogout()
                print("AuthState - 로그아웃 \(self.authState)")
            }
        default:
            break
        }
    }
    
    /// `FirebaseAuth` 로그아웃
    func signOut() async throws {
        if let user = Auth.auth().currentUser {
            
            // Sign out current authenticated user in Firebase
            do {
                await firebaseProviderSignOut()
                self.resetAuth()
                //                self.configureAuthStateChanges()
            }
        }
    }
    
    // 다 토큰 없애야 할듯..?
    /// 계정삭제 - 회원탈퇴
    func deleteAccount() async {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                Task {  // 카카오톡일 때 로그아웃 후 삭제 -> 토큰 문제
                    if let error = error {
                        print("Firebase Error : ",error)
                    } else {
                        print("회원탈퇴 성공!")
                        print("현재 로그인 플랫폼? - \(self.currentUser?.loginPlatform)")
                        
                        // 토큰을 없앰
                        switch AuthService.shared.tempUser?.loginPlatform {
                        case .kakakotalk:
                            try await FirebaseManager.shared.deleteData(collectionName: "Users", byId: user.uid)
                            await KakaoAuthService.shared.unlinkKakao()
                        case .apple:
                            await AppleAuthService.shared.signOutFromApple()
                            try await FirebaseManager.shared.deleteData(collectionName: "Users", byId: user.uid)
                        case .google:
                            try await FirebaseManager.shared.deleteData(collectionName: "Users", byId: user.uid)
                            print("Firestore - 현재 User 삭제 성공")
                        default:
                            print("회원탈퇴 실패~~ 플랫폼이 nil임")
                        }
                        self.authState = .signedOut
                    }
                }
            }
        } else {
            print("로그인 정보가 존재하지 않습니다")
        }
    }
    
    // TODO: 계정별로 token revoke 등의 행위를 해줘야 함
    // 중복코드이기는 함
    func deleteAuth() async {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                Task {  // 카카오톡일 때 로그아웃 후 삭제 -> 토큰 문제
                    if let error = error {
                        print("Firebase Error : ",error)
                    } else {
                        for profile in user.providerData {
                            switch profile.providerID {
                            case "password":  // 카카오 - Auth email로 로그인 관리
                                await KakaoAuthService.shared.unlinkKakao()
                            case "google.com":
                                print("구글 회원탈퇴~")
                            case "apple.com":
                                await AppleAuthService.shared.signOutFromApple()
                            default:
                                print("지원하는 계정 외에 것으로 로그인 혹은 에러")
                            }
                            
                            print("사용자는 \(profile.providerID)를 통해 로그인했습니다.")
                            
                        }
                    }
                }
            }
        } else {
            print("현재 로그인된 사용자가 없습니다.")
        }
    }
}
    
    // MARK: - Login 메서드
    extension LoginViewModel {
        // 애플 로그인
        func handleAppleID(_ result: Result<ASAuthorization, Error>) {
            if case let .success(auth) = result {
                guard let appleIDCredentials = auth.credential as? ASAuthorizationAppleIDCredential else {
                    print("AppleAuthorization failed: AppleID credential not available")
                    return
                }
                
                Task {
                    do {
                        let result = try await self.appleAuth(
                            appleIDCredentials,
                            nonce: AppleAuthService.nonce
                        )
                        if let result = result {
                            print("애플 로그인 성공 - \(result)")
                            dump(result.user)
                            let user = result.user
                            print("애플 회원가입 - user.nickname = \(user.displayName)")
                            
                            // 닉네임은 다르게 가져와야 함!!!
                            if let fullName = appleIDCredentials.fullName {
                                let name = "\(fullName.givenName ?? "") \(fullName.familyName ?? "")"
                            }
                            
                            // TODO: id 빼고 못가져오기 때문에, 이름까지 가져오도록 수정
                            await AuthService.shared.setTempUser(id: user.uid,
                                                                 nickname: user.displayName ?? "닉네임",
                                                                 profileImage: user.photoURL?.absoluteString ?? "",
                                                                 apnsToken: "애플",
                                                                 loginPlatform: .apple)
                        }
                    } catch {
                        print("AppleAuthorization failed: \(error)")
                        // Here you can show error message to user.
                    }
                }
            }
            else if case let .failure(error) = result {
                print("AppleAuthorization failed: \(error)")
            }
        }
        
        // 카카오 로그인
        func signInWithKakao() async {
            await KakaoAuthService.shared.handleKakaoLogin()
            print(#fileID, #function, #line, "- 카카오 로그인 정보 \(self.currentUser)")
        }
        
        /// 구글 로그인
        func signInWithGoogle() async {
            await GoogleAuthSerVice.shared.signInWithGoogle { user, error in
                if let error {
                    print("GoogleSignInError: failed to sign in with Google, \(error))")
                }
                
                guard let gidUser = user else { return }
                Task {
                    do {
                        let result = try await self.googleAuth(gidUser)
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
        
    }
