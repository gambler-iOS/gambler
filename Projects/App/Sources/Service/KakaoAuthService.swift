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
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalk() success.")
                _ = oauthToken
            }
        }
    }
    
    /// 카카오 웹뷰로 로그인
    fileprivate func handleLoginWithKakaoAccount() async {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(#fileID, #function, #line, "- 카카오 앱을 통한 로그인 실패 - \(error) ")
            } else {
                print("loginWithKakaoAccount() success.")
                //do something
                _ = oauthToken
            }
        }
    }
}
