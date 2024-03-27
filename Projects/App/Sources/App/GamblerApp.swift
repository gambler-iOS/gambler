//
//  GamblerApp.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/1/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import CoreLocation
import SwiftData
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoMapsSDK
import GoogleSignIn

@main
struct GamblerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] ?? ""
        SDKInitializer.InitSDK(appKey: "\(kakaoAppKey)")
        KakaoSDK.initSDK(appKey: kakaoAppKey as? String ?? "")
        
        UITabBar.appearance().scrollEdgeAppearance = .init()
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
    
    @StateObject private var myPageViewModel = MyPageViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var appNavigationPath = AppNavigationPath()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var gameListViewModel = GameListViewModel()
    @StateObject private var gameDetailViewModel = GameDetailViewModel()
    @StateObject private var shopListViewModel = ShopListViewModel()
    @StateObject private var reviewViewModel = ReviewViewModel()
    @StateObject private var tabSelection = TabSelection()
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .onAppear {
                    Task {
                        await startTask()
                    }
                }
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
            //            MainView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(homeViewModel)
        .environmentObject(appNavigationPath)
        .environmentObject(gameListViewModel)
        .environmentObject(gameDetailViewModel)
        .environmentObject(shopListViewModel)
        .environmentObject(myPageViewModel)
        .environmentObject(loginViewModel)
        .environmentObject(reviewViewModel)
        .environmentObject(tabSelection)
    }
    
    func startTask() async {
        let locationManager = CLLocationManager()
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .denied {
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        } else if authorizationStatus == .restricted || authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
