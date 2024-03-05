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

@MainActor
final class KakaoAuthService {
    static let shared = KakaoAuthService()
    
    private let kakao = UserApi.shared
    
    private init() { }
    
    func handleKakaoLogin() {
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
                let isLogedin = await AuthService.shared.loginWithEmail(email: email, password: password)
                
                if !isLogedin {
                    try await AuthService.shared.createUser(email: email,
                                                            password: password,
                                                            name: name,
                                                            profileImageURL: profileImageURL)
                    
                    //                    await self.login(email: email, password: password)
                }
            }
        }
    }
}
