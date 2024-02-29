//
//  GamblerApp.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/1/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import SwiftData
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct GamblerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        // kakaoAppKey에 번들 메인 리소스 infoDictionary에서 키 이름으로 가져와서 할당
//        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] ?? ""
   
        print(#fileID, #function, #line, "- kakaoAppKey: \(kakaoAppKey) ")
        
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey as? String ?? "")
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SearchKeyword.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
            //            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

struct ContentView: View {
    var body: some View {
        Text("테스트")
            .font(.head1B)
        Text("테스트")
        Text("테스트")
            .font(.head1B)
            .foregroundStyle(Color.primaryDefault)
        GamblerAsset.bell.swiftUIImage
            .renderingMode(.template) // 렌더링 모드 설정 시 색상 변경 가능
            .foregroundStyle(Color.gray300)
    }
}

#Preview {
    ContentView()
}
