//
//  KakaoService.swift
//  gambler
//
//  Created by 박성훈 on 3/5/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth

@MainActor
final class KakaoAuthService {
    static let shared = KakaoAuthService()
    
    private let kakao = UserApi.shared
    
    var createKakaoAccount: Bool = false
    
    typealias KakaoAuthResult = (KakaoSDKUser.User?, Bool)  // 유저정보, 토큰활성여부(Bool)
    
    private init() { }
    
    // 사용자에게 카카오 로그인을 요청 / 사용자는 카카오 로그인 완료
    func handleKakaoLogin() async {
        // 카카오 토큰이 존재한다면
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if let error {
                    print("DEBUG: 카카오톡 토큰 가져오기 에러 \(error.localizedDescription)")
                    self.kakaoLogin()
                } else {
                    // 토큰 유효성 체크 성공 (필요 시 토큰 생신됨)
                    self.kakaoTalkloginInFirebase()
                }
            }
        } else {
            // 토큰이 없는 상태 로그인 필요
            self.kakaoLogin()
        }
    }
    
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginInApp() // 카카오톡 앱이 있다면 앱으로 로그인
        } else {
            kakaoLoginInWeb() // 앱이 없다면 웹으로 로그인 (시뮬레이터)
        }
    }
    
    // - 카카오 인증 서버에 사용자 정보를 가져오기 위해 토큰 발급을 요청합니다.
    // - 토큰을 발급 받으면 토큰과 함께 사용자 정보를 요청합니다. (이메일, userID)
    // - 토큰 검증 완료 후 사용자 정보를 제공받습니다.
    private func kakaoLoginInApp() {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.kakaoTalkloginInFirebase()
                }
            }
        }
    }
    
    private func kakaoLoginInWeb() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.kakaoTalkloginInFirebase()
                }
            }
        }
    }
    
    // 파이어베이스 인증 서버에 이메일/userID로 회원가입 및 로그인을 완료합니다.
    // 로그인 여부를 확인합니다.
    private func kakaoTalkloginInFirebase() {
        UserApi.shared.me() { user, error in
            if let error = error {
                print("DEBUG: 카카오톡 사용자 정보가져오기 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 사용자 정보가져오기 success.")
                
                guard let email = user?.kakaoAccount?.email else { return }
                guard let name = user?.kakaoAccount?.profile?.nickname else { return }
                guard let profileImageURL = user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString else { return }
                let password: String = String(describing: user?.id)
                
                // 파이어베이스 유저 생성 (이메일로 회원가입)
                Task {
                    await AuthService.shared.createUser(email: email,
                                                        password: password,
                                                        name: name,
                                                        profileImageURL: profileImageURL)
                }
            }
        }
    }
    
    
    
    // MARK: - 기존 코드~
    //    func handleKakaoLogin() async {
    //        if AuthApi.hasToken() {
    //            UserApi.shared.accessTokenInfo { _, error in
    //                Task {
    //                    if error != nil {
    //                        // 토큰이 유효하지 않으면 로그인(로그인 시켜서 토큰을 다시 받음)
    //                        self.handleKakaoLoginLogic()
    //                    } else {
    //                        await self.loadingInfoDidKakaoAuth()
    //                    }
    //                }
    //            }
    //        } else { // 토큰 없으면 로그인
    //            self.handleKakaoLoginLogic()
    //        }
    //    }
    
    private func handleKakaoLoginLogic() {
        Task {
            // 카카오톡 설치 여부 확인 -
            if UserApi.isKakaoTalkLoginAvailable() {  // 설치 되어있을 때(앱으로 로그인)
                await handleLoginWithKakaoTalkApp()
            } else {  // 설치 안되어있을 때(웹뷰로 로그인)
                await handleLoginWithKakaoAccount()
            }
        }
    }
    
    func handleKakaoLogout() async {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
        }
    }
    
    func unlinkKakao() async {
        UserApi.shared.unlink { (error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
            }
        }
    }
    
    /// 카카오 앱을 통해 로그인
    fileprivate func handleLoginWithKakaoTalkApp() async {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error {
                print("Kakao Sign In Error: \(error)")
            } else {
                print("loginWithKakaoTalk() success.")
                _ = oauthToken
                
                Task {
                    await self.loadingInfoDidKakaoAuth()
                }
            }
        }
    }
    
    /// 카카오 웹뷰로 로그인
    fileprivate func handleLoginWithKakaoAccount() async {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error {
                print(#fileID, #function, #line, "- 카카오 앱을 통한 로그인 실패 - \(error) ")
            } else {
                print("loginWithKakaoAccount() success.")
                _ = oauthToken
                
                Task {
                    await self.loadingInfoDidKakaoAuth()
                }
            }
        }
    }
    
    func loadingInfoDidKakaoAuth() async {  // 사용자 정보 불러오기
        UserApi.shared.me { kakaoUser, error in
            if error != nil {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                
                return
            }
            
            guard let email = kakaoUser?.kakaoAccount?.email else { return }
            guard let name = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
            guard let profileImageURL = kakaoUser?.kakaoAccount?.profile?.profileImageUrl?.absoluteString else { return }
            let password = String(describing: kakaoUser?.id)
            
            // 로그인 되면 그냥 로그인, 안되면 회원가입 후 로그인
            Task {
                if await AuthService.shared.loginWithEmail(email: email, password: password) {
                    print("카카오 이메일 로그인 성공")
                } else {
                    await AuthService.shared.createUser(email: email,
                                                        password: password,
                                                        name: name,
                                                        profileImageURL: profileImageURL)
                    
                    print("카카오 회원가입 성공~")
                    //                    await AuthService.shared.loginWithEmail(email: email, password: password)
                }
                
                //                if !isLogedin {
                //                    try await AuthService.shared.createUser(email: email,
                //                                                            password: password,
                //                                                            name: name,
                //                                                            profileImageURL: profileImageURL)
                //                }
            }
        }
    }
}
