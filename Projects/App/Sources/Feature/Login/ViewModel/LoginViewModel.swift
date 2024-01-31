////
////  LoginViewModel.swift
////  gambler
////
////  Created by 박성훈 on 1/27/24.
////  Copyright © 2024 gambler. All rights reserved.
////
//
//import Foundation
//import Firebase
//import GoogleSignIn
//
//final class LoginViewModel: ObservableObject {
//    @Published var signState: SignState = .signOut
//    
//    enum SignState {
//        case signIn
//        case signOut
//    }
//    
//    func emailAuthSignup(email: String, userName: String, password: String, completion: (() -> Void)?) {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error {
//                print("error: \(error.localizedDescription)")
//            }
//            if result != nil {
//                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//                changeRequest?.displayName = userName
//                print("사용자 이메일: \(String(describing: result?.user.email))")
//            }
//            completion?()
//        }
//    }
//    
//    
//    // MARK: - kakao 로그인
////    func kakaoSignIn() {
////        if AuthApi.hasToken() {  // 발급된 토큰이 있는지
////            UserApi.shared.accessTokenInfo { _, error in
////                if let error {
////                    self.openKakaoService()
////                } else {
////                    self.loadingInfoDidKakaoAuth()
////                }
////            } else {  // 만료된 토큰
////                self.openKakaoService()
////            }
////
////        }
////    }
//    
//    
//    
//    // MARK: - google 로그인
//    // 프로필 이미지 받아올 수 있도록 하기
//    // 닉네임 받아오기
//    func googleSignIn() {
//        // 1
//        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
//            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
//                authenticateUser(for: user, with: error)
//            }
//        } else {
//            // 2
//            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//            
//            // 3
//            let configuration = GIDConfiguration(clientID: clientID)
//            GIDSignIn.sharedInstance.configuration = configuration
//            
//            // 4
//            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
//            
//            // 5
//            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {[unowned self] result, error in
//                guard let result = result else { return }
//                authenticateUser(for: result.user, with: error)
//            }
//        }
//    }
//    
//    // firebase 로그인 절차
//    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
//        // 1
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        // 2
//        guard let accessToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//        
//        // 3
//        Auth.auth().signIn(with: credential) { (_, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                self.signState = .signIn
//            }
//        }
//    }
//    
//    // 로그아웃 절차
//    func googleSignOut() {
//        // 1
//        GIDSignIn.sharedInstance.signOut()
//        
//        do {
//            // 2
//            try Auth.auth().signOut()
//            self.signState = .signOut
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    
//}
