//
//  GamblerApp.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/1/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

@main
struct GamblerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
//                .environmentObject(authViewModel)
//                .onOpenURL { loginUrl in  // 뷰가 속한 Window에 대한 URL을 받았을 때 호출할 Handler를 등록하는 함수
//                    if AuthApi.isKakaoTalkLoginUrl(loginUrl) {
//                        _ = AuthController.handleOpenUrl(url: loginUrl)
//                    }
//                }
        }
    }
}
