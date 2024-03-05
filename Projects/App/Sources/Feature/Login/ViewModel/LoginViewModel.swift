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

enum AuthState {
    case signedIn
    case signedOut
}

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
        
        Task {
            try await fetchUserData()
        }
        
    }
    
    // MARK: - Auth State
    /// 권한 부여 상태 변경에 대한 리스너를 추가
    func configureAuthStateChanges() {
        authStateHandle = Auth.auth().addStateDidChangeListener { _, user in
            print("Auth changed: \(user != nil)")
            print("\(self.authState)")
            self.updateState(user: user)
        }
    }
    
    /// 권한 부여 상태의 변경 사항에 대한 리스너를 제거
    func removeAuthStateListener() {
        Auth.auth().removeStateDidChangeListener(authStateHandle)
    }
    
    /// Update auth state for given user.
    /// - Parameter user: `Optional` firebase user.
    func updateState(user: FirebaseAuth.User?) {
        self.userSession = user
        let isAuthenticatedUser = user != nil
        
        if isAuthenticatedUser {
            self.authState = .signedIn
            Task {
                try await fetchUserData()
            }
        } else {
            self.authState = .signedOut
            self.currentUser = nil
            self.userSession = nil
        }
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
            updateState(user: result.user)
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
            updateState(user: result.user)
            
            return result
        } catch {
            print("FirebaseAuthError: link(with:) failed, \(error)")
            if let error = error as NSError? {
                if let code = AuthErrorCode.Code(rawValue: error.code),
                   authLinkErrors.contains(code) {
                    
                    // If provider is "apple.com", get updated AppleID credentials from the error object.
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
    
    fileprivate func isNewUser(user: FirebaseAuth.User) async throws -> Bool {
        let createDate = user.metadata.creationDate
        guard let createDate else {
            return true
        }
        return Date() > createDate
    }
    
    // MARK: - FireStore
    
    // 유저 정보 가져오기
    func fetchUserData() async throws {
        self.userSession = Auth.auth().currentUser
        print("Auth.currentUser: \(String(describing: userSession))")
        
        guard let currentUid = userSession?.uid else {
            print("로그인된 유저 없음")
            return
        }
        print("UID = \(currentUid)")
        
        do {
            currentUser = await FirebaseManager.shared.fetchOneData(collectionName: "Users", objectType: User.self, byId: currentUid)
            print("유저 데이터 읽기 성공")
            dump(currentUser)
        }
    }
    
    /// 각 플랫폼 별 로그아웃 - 로그인되어있는 유저의 loginPlatform으로 분기
    func firebaseProviderSignOut() async {
        let platform = currentUser?.loginPlatform
        
        switch platform {
        case .apple:
            break  // 애플 로그아웃
        case .google:
            Task {
                await GoogleAuthSerVice.shared.signOutFromGoogle()
            }
        case .kakakotalk:
            Task {
                try Auth.auth().signOut()
                await KakaoAuthService.shared.handleKakaoLogout()
            }
        default:
            break
        }
        
        self.currentUser = nil
        self.userSession = nil
    }
    
    /// `FirebaseAuth` 로그아웃
    func signOut() async throws {
        if let user = Auth.auth().currentUser {
            
            // Sign out current authenticated user in Firebase
            do {
                await firebaseProviderSignOut()
                try Auth.auth().signOut()
                self.authState = .signedOut
            }
        }
    }
    
    /// 계정삭제 - 회원탈퇴
    func deleteAccount() async {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("Firebase Error : ",error)
                } else {
                    print("회원탈퇴 성공!")
                    Task {  // 카카오톡일 때 로그아웃 후 삭제 -> 토큰 문제
                        // 토큰을 없앰
                        if self.currentUser?.loginPlatform == .kakakotalk {
                            await KakaoAuthService.shared.handleKakaoLogout()
                        }
                        try await FirebaseManager.shared.deleteData(collectionName: "Users", byId: user.uid)
                        print("Firestore - 현재 User 삭제 성공")
                    }
                }
            }
        } else {
            print("로그인 정보가 존재하지 않습니다")
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
                        //                        dismiss()
                        print("애플 로그인 성공 - \(result)")
                        
                    }
                } catch {
                    print("AppleAuthorization failed: \(error)")
                    // Here you can show error message to user.
                }
            }
        }
        else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
            // Here you can show error message to user.
        }
    }
    
    // 카카오 로그인
    func signInWithKakao() async {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if error != nil {
                    // 토큰이 유효하지 않으면 로그인(로그인 시켜서 토큰을 다시 받음)
                    KakaoAuthService.shared.handleKakaoLogin()
                } else {  // ???
                    Task {
                        await KakaoAuthService.shared.loadingInfoDidKakaoAuth()
                    }
                }
            }
        } else { // 토큰 없으면 로그인
            KakaoAuthService.shared.handleKakaoLogin()
        }
    }
    
    // 구글 로그인
    func signInWithGoogle() async {
        await GoogleAuthSerVice.shared.signInWithGoogle { user, error in
            if let error {
                print("GoogleSignInError: failed to sign in with Google, \(error))")
                return
            }
            
            guard let user = user else { return }
            Task {
                do {
                    let result = try await self.googleAuth(user)
                    if let result {
                        print("GoogleSignInSuccess: \(result.user.uid)")
                        let user = result.user
                        
                        // 이거 때문에 조금 느릴지도...?
                        let newUser = try await self.isNewUser(user: user)
                        
                        if newUser {
                            AuthService.shared.uploadUserToFirestore(userId: user.uid,
                                                                     name: user.displayName ?? "무명",
                                                                     profileImageURL: user.photoURL?.absoluteString ?? "",
                                                                     apnsToken: "구글",
                                                                     loginPlatform: .google)
                        }
                    }
                } catch {
                    print("GoogleSignInError: failed to authenticate with Google, \(error))")
                }
            }
            
        }
    }
    
}
