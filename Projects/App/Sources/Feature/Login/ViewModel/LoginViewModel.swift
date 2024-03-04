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
            try await loadUserData()
        }
        
    }
    
    // MARK: - Auth State
    // 2.
    /// 권한 부여 상태 변경에 대한 리스너를 추가
    func configureAuthStateChanges() {
        authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
            print("Auth changed: \(user != nil)")
            print("\(self.authState)")
            self.updateState(user: user)
        }
    }
    
    // 2.
    /// 권한 부여 상태의 변경 사항에 대한 리스너를 제거
    func removeAuthStateListener() {
        Auth.auth().removeStateDidChangeListener(authStateHandle)
    }
    
    /// Update auth state for given user.
    /// - Parameter user: `Optional` firebase user.
    func updateState(user: FirebaseAuth.User?) {
        self.userSession = user
        let isAuthenticatedUser = user != nil
        let isAnonymous = user?.isAnonymous ?? false
        
        if isAuthenticatedUser {
            self.authState = .signedIn
        } else {
            self.authState = .signedOut
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
    // AuthCredential을 받고 인증된 사용자가 있는지 확인
    private func authenticateUser(credentials: AuthCredential) async throws -> AuthDataResult? {
        // If we have authenticated user, then link with given credentials.
        // Otherwise, sign in using given credentials.
        if Auth.auth().currentUser != nil {
            return try await authLink(credentials: credentials)
        } else {
            return try await authSignIn(credentials: credentials)
        }
    }
    
    /// Authenticate with Firebase using Google `idToken`, and `accessToken` from given `GIDGoogleUser`.
    /// - Parameter user: Signed-in Google user.
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
        
        // Initialize a Firebase credential, including the user's full name.
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
    

 
    
    // MARK: - SignInWithGoogle
    @MainActor
    func signInWithGoogle() {
        GoogleAuthSerVice.shared.signInWithGoogle { user, error in
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
                        
                        let newUser = try await self.isNewUser(user: user)
                        
                        if newUser {
                            self.uploadUserToFirestore(userId: user.uid,
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
    
    // MARK: - FireStore
    func loadUserData() async throws {
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
    
    func uploadUserToFirestore(userId: String, name: String, profileImageURL: String, apnsToken: String, loginPlatform: LoginPlatform) {
        
        let user = User(id: userId,
                        nickname: name,
                        profileImageURL: profileImageURL,
                        apnsToken: apnsToken,
                        createdDate: Date(),
                        likeGameId: [],
                        likeShopId: [],
                        myReviewsCount: 0,
                        myLikesCount: 0,
                        loginPlatform: loginPlatform
        )
        
        do {
            try FirebaseManager.shared.createData(collectionName: "Users", data: user)
        } catch {
            print("Firestore에 올리기 실패, \(error)")
        }
        
    }
    
    func isNewUser(user: FirebaseAuth.User) async throws -> Bool {
        let createDate = user.metadata.creationDate
        guard let createDate else {
            return true
        }
        return Date() > createDate  // 현재 날짜 > 생성일 같겠지? 그럼 올려야지
    }
    
    /// 이메일 회원가입(FirebaseStore에도 등록) ->  카카오가입할때
    @MainActor
    func createUser(email: String, password: String, name: String, profileImageURL: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            self.userSession = result.user
            uploadUserToFirestore(userId: result.user.uid,
                                  name: name,
                                  profileImageURL: profileImageURL,
                                  apnsToken: "카카오톡",
                                  loginPlatform: .kakakotalk)
            print("회원가입 성공")
        } catch {
            print("회원가입 실패. 에러메세지: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 이메일 로그인
    @MainActor
    func login(email: String, password: String) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            print("로그인 성공")
        } catch let error as NSError {
            switch AuthErrorCode.Code(rawValue: error.code) {
            case .wrongPassword:  // 잘못된 비밀번호
                break
            case .userTokenExpired: // 사용자 토큰 만료 -> 사용자가 다른 기기에서 계정 비밀번호를 변경했을수도 있음. -> 재로그인 해야함.
                break
            case .tooManyRequests: // Firebase 인증 서버로 비정상적인 횟수만큼 요청이 이루어져 요청을 차단함.
                break
            case .userNotFound: // 사용자 계정을 찾을 수 없음.
                break
            case .networkError: // 작업 중 네트워크 오류 발생
                break
            default:
                break
            }
            print("로그인 실패. 에러메세지: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Sign Out
    /// Sign out a user from Firebase Provider.
    func firebaseProviderSignOut(_ user: FirebaseAuth.User) async {
        let providers = user.providerData
            .map { $0.providerID }.joined(separator: ", ")
        
        if providers.contains("apple.com") {
            // TODO: Sign out from Apple
        }
        if providers.contains("google.com") {
            GoogleAuthSerVice.shared.signOutFromGoogle()
        }
        
        if providers.contains("kakao.com") {  // 카카오는 꼭 kakao.com이 아닐 수도 있음
            // email logout
        }
    }
    
    /// Sign out current `Firebase` auth user
    func signOut() async throws {
        if let user = Auth.auth().currentUser {
            
            // Sign out current authenticated user in Firebase
            do {
                await firebaseProviderSignOut(user)
                try Auth.auth().signOut()
                self.authState = .signedOut
            } catch let error as NSError {
                print("FirebaseAuthError: failed to sign out from Firebase, \(error)")
                throw error
            }
        }
    }
    
    fileprivate func deleteAccount() {
        if  let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("Firebase Error : ",error)
                } else {
                    print("회원탈퇴 성공!")
                    // FireStore 데이터도 지워야 함
                    // delete가 없음 ㅜ FirebaseManager.shared
                }
            }
        } else {
            print("로그인 정보가 존재하지 않습니다")
        }
    }
}
