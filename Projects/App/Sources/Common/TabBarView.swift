//
//  TabBarView.swift
//  gambler
//
//  Created by cha_nyeong on 2/14/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    @State private var draw = false
    @StateObject private var myPageViewModel = MyPageViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var appNavigationPath = AppNavigationPath()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var gameListViewModel = GameListViewModel()
    @StateObject private var gameDetailViewModel = GameDetailViewModel()
    @StateObject private var shopListViewModel = ShopListViewModel()
    @StateObject private var reviewViewModel = ReviewViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
                .environmentObject(homeViewModel)
                .environmentObject(appNavigationPath)
                .environmentObject(gameListViewModel)
                .environmentObject(gameDetailViewModel)
                .environmentObject(shopListViewModel)
                .tabItem {
                    HStack {
                        (selectedTab == 0 ?
                         GamblerAsset.tabHomeSelected.swiftUIImage : GamblerAsset.tabHome.swiftUIImage)
                        Text("홈")
                    }
                }
                .tag(0)
            
            MapView(draw: $draw)
                .tabItem {
                    HStack {
                        (selectedTab == 1 ?
                         GamblerAsset.tabMapSelected.swiftUIImage : GamblerAsset.tabMap.swiftUIImage)
                        Text("내 주변")
                        
                    }
                }
                .tag(1)
            
            SearchMainView()
                .tabItem {
                    HStack {
                        (selectedTab == 2 ?
                         GamblerAsset.tabSearchSelected.swiftUIImage : GamblerAsset.tabSearch.swiftUIImage)
                        Text("검색")
                    }
                }
                .tag(2)
            
            MyPageView()
                .environmentObject(myPageViewModel)
                .tabItem {
                    HStack {
                        (selectedTab == 3 ?
                         GamblerAsset.tabProfileSelected.swiftUIImage : GamblerAsset.tabProfile.swiftUIImage)
                        Text("마이")
                    }
                }
                .tag(3)
        }
        .tint(Color.primaryDefault)
        .environmentObject(loginViewModel)
        .environmentObject(reviewViewModel)
        .onAppear {
            self.draw = true
        }
        .onDisappear {
            self.draw = false
        }
    }
}

#Preview {
    TabBarView()
}
