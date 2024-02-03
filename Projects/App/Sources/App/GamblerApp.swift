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
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var shopDetailViewModel = ShopDetailViewModel()
    @StateObject private var reviewViewModel = ReviewViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(homeViewModel)
                .environmentObject(shopDetailViewModel)
                .environmentObject(reviewViewModel)
        }
    }
}
