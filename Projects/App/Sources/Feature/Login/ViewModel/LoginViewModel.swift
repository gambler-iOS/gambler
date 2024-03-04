//
//  LoginViewModel.swift
//  gambler
//
//  Created by 박성훈 on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices  // 애플 로그인

enum SignInState {
    case authenticated  // Firebase에서 익명으로 인증
    case signedIn  // 서비스 제공업체 중 하나를 사용하여 Firebase에서 인증되었습니다.
    case signedOut  // Firebase에서 인증되지 않았습니다.
}

@MainActor
final class LoginViewModel: ObservableObject {
}
//
//    @Published var user: User?  // 현재 Firebase 인증 사용자.
//    @Published var state: SignInState = .signedOut  // 현재 사용자의 인증 상태
//    private var authStateHandle: AuthStateDidChangeListenerHandle!
//
////    @Published var currentUser: Firebase.User?
//    @Published var loginPlatoform: LoginPlatform = .apple
//    @Published var errorMessage: String = ""
//    @Published var userSession: FirebaseAuth.User?
//    
//    /// 일반적인 인증 링크 오류
//    private let authLinkErrors: [AuthErrorCode.Code] = [
//            .emailAlreadyInUse,
//            .credentialAlreadyInUse,  // 이미 다른 Firebase 계정에 연결된 자격 증명으로 연결하려는 시도
//            .providerAlreadyLinked  // 계정이 이미 연결되어 있는 공급업체를 연결하려는 시도
//    ]
//    
//
//    let anyImage: String = "https://beziergames.com/cdn/shop/products/UltimateAccessoryPack_800x.png?v=1587055236"
//    private let firebaseManager = FirebaseManager.shared
//    
//    init() {
//        
//        user = Auth.auth().currentUser
//    }
//    
//    // 유저정보를 firebase에 추가하기
//    // 이 전에 이미지 받아서 파이어베이스 스토어에 넣고, 그 이미지의 url을 받아서 파베에 넣으면 됨
//    // 닉네임 받아오고, 이미지 받아오고, 앱 토큰 받아오기
//    
//    // 카카오톡 / 구글 / 애플 분기해야 함
//    private func createUserFirestore(user: User) async {
//        
//        do {
//            try firebaseManager.createData(
//                collectionName: "Users",
//                data: User(
//                    id: user.id,
//                    nickname: user.nickname,
//                    profileImageURL: user.profileImageURL,
//                    apnsToken: user.apnsToken,
//                    createdDate: user.createdDate,
//                    likeGameId: user.likeGameId,
//                    likeShopId: user.likeGameId,
//                    myReviewsCount: user.myReviewsCount,
//                    myLikesCount: user.myLikesCount,
//                    loginPlatform: user.loginPlatform)
//            )
//            print("createUserFirebase 실행!!!")
//        } catch {
//            print("\(error)")
//        }
//        
//    }
    
    // MARK: - FirebaseAuth Function
    // completionHandler (클로저)를 통한 비동기 방식으로 실행
    //    @MainActor
    //    func emailAuthSignUp(email: String,
    //                         nickname: String,
    //                         password: String,
    //                         profileImageURL: String?,
    //                         apnsToken: String,
    //                         completion: (() -> Void)?) {
    //
    //        Auth.auth().createUser(withEmail: email, password: password) { result, error in
    //            if let error {
    //                print("error: \(error.localizedDescription)")
    //            }
    //            if result != nil {
    //                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    //                changeRequest?.displayName = nickname
    //                print("사용자 이메일: \(String(describing: result?.user.email))")
    //
    //                Task {
    //                    await self.createUserFirebase(nickname: nickname, profileImageURL: profileImageURL ?? self.anyImage, apnsToken: apnsToken)
    //                }
    //            }
    //
    //            completion?()
    //        }
    //
//    @MainActor
//    func emailAuthSignUp(email: String,
//                         nickname: String,
//                         password: String,
//                         profileImageURL: String?,
//                         apnsToken: String
//    ) async throws {
//        do {
//            let result = try await Auth.auth().createUser(withEmail: email, password: password)
//            self.userSession = result.user
//            
//            let user = User(id: result.user.uid,
//                            nickname: nickname,
//                            profileImageURL: profileImageURL ?? self.anyImage,
//                            createdDate: Date(),
//                            myReviewsCount: 0,
//                            myLikesCount: 0,
//                            loginPlatform: .kakakotalk)
//            
//            await createUserFirestore(user: user)
//            print("파이어스토어 올림ㅎㅎ")
//        } catch {
//            print("회원가입 실패 - error: \(error.localizedDescription)")
//            throw error
//        }
//    }
//    
//    func emailAuthSignIn(email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error {
//                print("error: \(error.localizedDescription)")
//                
//                return
//            }
//            
//            if result != nil {
//                self.state = .signedIn
//                print("사용자 이메일: \(String(describing: result?.user.email))")
//                print("사용자 이름: \(String(describing: result?.user.displayName))")
//                
//            }
//        }
//    }
//    
//    // MARK: - KakaoAuth SignIn Function
//    @MainActor
//    func kakaoAuthSignIn() {
//        if AuthApi.hasToken() { // 발급된 토큰이 있는지
//            UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
//                if let error = error { // 에러가 발생했으면 토큰이 유효하지 않다.
//                    Task {
//                        if UserApi.isKakaoTalkLoginAvailable() {
//                            if await self.handleSignInWithKakaoTalkApp() {
//                                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
//                            }
//                        } else {
//                            if await self.handleSignInWithKakaoAccount() {
//                                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
//                            }
//                        }
//                    }
//                    self.openKakaoService()
//                } else { // 유효한 토큰
//                    self.loadingInfoDidKakaoAuth()
//                }
//            }
//        } else { // 만료된 토큰
//            self.openKakaoService()
//        }
//    }
//    
//    func handleSignInWithKakaoTalkApp() async -> Bool {
//        await withCheckedContinuation { continuation in
//            UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
//                if let error = error { // 로그인 실패 -> 종료
//                    print("Kakao Sign In Error: ", error.localizedDescription)
//                    continuation.resume(returning: false)
//                }
//                
//                _ = oauthToken // 로그인 성공
//                continuation.resume(returning: true)
//                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
//            }
//        }
//    }
//    
//    func handleSignInWithKakaoAccount() async -> Bool {
//        await withCheckedContinuation { continuation in
//            UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
//                if let error = error { // 로그인 실패 -> 종료
//                    print("Kakao Sign In Error: ", error.localizedDescription)
//                    continuation.resume(returning: false)
//                }
//                _ = oauthToken // 로그인 성공
//                continuation.resume(returning: true)
//                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
//            }
//        }
//    }
//    
//    func openKakaoService() {
//        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
//            UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
//                if let error = error { // 로그인 실패 -> 종료
//                    print("Kakao Sign In Error: ", error.localizedDescription)
//                    return
//                }
//                
//                _ = oauthToken // 로그인 성공
//                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
//            }
//        } else { // 카카오톡 앱 이용 불가능한 사람
//            UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
//                if let error = error { // 로그인 실패 -> 종료
//                    print("Kakao Sign In Error: ", error.localizedDescription)
//                    return
//                }
//                _ = oauthToken // 로그인 성공
//                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
//            }
//        }
//    }
//    
//    func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
//        UserApi.shared.me { kakaoUser, error in
//            if let error = error {
//                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
//                
//                return
//            }
//            guard let email = kakaoUser?.kakaoAccount?.email else { return }
//            guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
//            guard let password = kakaoUser?.id else { return }
//            let profileImageURL = kakaoUser?.kakaoAccount?.profile?.profileImageUrl?.absoluteString
//            
//            // 회원가입 한 후에, 이 데이터로 로그인까지 하는 것
//            try await self.emailAuthSignUp(email: email, nickname: userName, password: "\(password)", profileImageURL: profileImageURL, apnsToken: "카카오 토큰")
//            self.emailAuthSignIn(email: email, password: "\(password)")
//            
//        }
//    }
//    
//    @MainActor
//    func kakaoSignOut() {
//        Task {
//            if await handleKakaoSignOut() {
//                state = .signedOut
//            }
//        }
//    }
//    
//    func handleKakaoSignOut() async -> Bool {  // 카카오 계정 로그아웃
//        await withCheckedContinuation { continuation in
//            UserApi.shared.logout {(error) in
//                if let error = error {
//                    print(error)
//                    continuation.resume(returning: false)
//                } else {
//                    print("logout() success.")
//                    continuation.resume(returning: true)
//                }
//            }
//        }
//        
//    }
//    
//    
//    
//}
//
//enum AuthenticationError: Error {
//    case tokenError(message: String)
//}

// MARK: - Google
//extension LoginViewModel {
//    
//    // 파이어스토어에 안올라감 ㅋㅎ
//    
//    @MainActor
//    /// 구글 로그인
//    /// - Returns: 성공 여부
//    func signInWithGoogle() async -> Bool {
//        // 1. Firebase 클라이언트 ID 얻기
//        guard let clientID = FirebaseApp.app()?.options.clientID else {
//            fatalError("No client ID found in Firebase congiguration")
//        }
//        
//        // 2. Google 로그인 구성 객체 생성
//        let confing = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = confing
//        
//        // 3. 루트 뷰 컨트롤러 확인
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = windowScene.windows.first,
//              let rootViewController = window.rootViewController else {
//            print("There is no root view controller!")
//            return false
//        }
//        
//        // 여기서 코드 분리해도 될듯
//        do {
//            // 4. Google 로그인 수행 (비동기)
//            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
//            
//            // 5. Google 사용자 정보 추출
//            let user = userAuthentication.user
//            
//            guard let idToken = user.idToken else {
//                throw AuthenticationError.tokenError(message: "ID token missing")
//            }
//            let accessToken = user.accessToken
//            
//            // 6. Firebase 인증 수행 (비동기)
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
//                                                           accessToken: accessToken.tokenString)
//            
//            let result = try await Auth.auth().signIn(with: credential)
//            let firebaseUser = result.user
//            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
//            
//            // Firebase 올리기
//            await self.cre(nickname: firebaseUser.displayName ?? "이름 없음",
//                                          profileImageURL: firebaseUser.photoURL?.absoluteString ?? self.anyImage,
//                                          apnsToken: "구글")
//            print("파베에 올려용~~~~")
//            
//            return true
//        } catch {
//            print(error.localizedDescription)
//            self.errorMessage = error.localizedDescription
//            return false
//        }
//    }
//    
//    /// 구글 로그아웃
//    func signOutwithGoogle() {
//        do {
//            try Auth.auth().signOut()
//            state = .signedOut
//        } catch {
//            print(error)
//            errorMessage = error.localizedDescription
//        }
//    }
//    
//    //    func deleteAccount() async -> Bool {
//    //      do {
//    //        try await user?.delete()
//    //        return true
//    //      }
//    //      catch {
//    //        errorMessage = error.localizedDescription
//    //        return false
//    //      }
//    //    }
//}
