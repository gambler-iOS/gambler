//
//  GamblerApp.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/1/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct GamblerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var loginViewModel: LoginViewModel = LoginViewModel()
    
    init() {
        // kakaoAppKey에 번들 메인 리소스 infoDictionary에서 키 이름으로 가져와서 할당
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        
        print(#fileID, #function, #line, "- kakaoAppKey: \(kakaoAppKey) ")
        
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey as? String ?? "")
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(loginViewModel)
            // 뷰가 속한 Window에 대한 URL을 받았을 때 호출할 Handler를 등록하는 함수
            // 카카오 로그인을 위해 웹 혹은 카카오톡 앱으로 이동 후 다시 앱으로 돌아오는 과정을 거쳐야하므로, Handler를 추가로 등록해줌
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
