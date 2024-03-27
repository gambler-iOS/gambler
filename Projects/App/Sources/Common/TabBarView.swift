//
//  TabBarView.swift
//  gambler
//
//  Created by cha_nyeong on 2/14/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

final class TabSelection: ObservableObject {
    @Published var selectedTab = 0
    
    func goToHomeTab() {
        selectedTab = 0
    }
}

struct TabBarView: View {
    @EnvironmentObject private var tabSelection: TabSelection
    @State private var draw = false
    @StateObject private var myPageViewModel = MyPageViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var appNavigationPath = AppNavigationPath()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var gameListViewModel = GameListViewModel()
    @StateObject private var gameDetailViewModel = GameDetailViewModel()
    @StateObject private var shopListViewModel = ShopListViewModel()
    @StateObject private var profileEditViewModel = ProfileEditViewModel()
    @StateObject private var reviewViewModel = ReviewViewModel()
    
    var body: some View {
        TabView(selection: $tabSelection.selectedTab) {
            
            HomeView()
                .environmentObject(homeViewModel)
                .environmentObject(appNavigationPath)
                .environmentObject(gameListViewModel)
                .environmentObject(gameDetailViewModel)
                .environmentObject(shopListViewModel)
                .tabItem {
                    HStack {
                        (tabSelection.selectedTab == 0 ?
                         GamblerAsset.tabHomeSelected.swiftUIImage : GamblerAsset.tabHome.swiftUIImage)
                        Text("홈")
                    }
                }
                .tag(0)
            
            MapView(draw: $draw)
                .tabItem {
                    HStack {
                        (tabSelection.selectedTab == 1 ?
                         GamblerAsset.tabMapSelected.swiftUIImage : GamblerAsset.tabMap.swiftUIImage)
                        Text("내 주변")
                        
                    }
                }
                .tag(1)
            
            SearchMainView()
                .tabItem {
                    HStack {
                        (tabSelection.selectedTab == 2 ?
                         GamblerAsset.tabSearchSelected.swiftUIImage : GamblerAsset.tabSearch.swiftUIImage)
                        Text("검색")
                    }
                }
                .tag(2)
            
            MyPageView()
                .environmentObject(myPageViewModel)
                .environmentObject(profileEditViewModel)
                .environmentObject(appNavigationPath)
                .tabItem {
                    HStack {
                        (tabSelection.selectedTab == 3 ?
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
        .environmentObject(TabSelection())
}
