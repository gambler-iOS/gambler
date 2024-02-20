//
//  HomeView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @ObservedObject private var eventBannerViewModel = EventBannerViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    EventBannerView(eventBannerViewModel: eventBannerViewModel)
                    HomeGameGridView(title: "채영님이 좋아하실 인기게임", games: homeViewModel.popularGames)
                    BorderView()
                    HomeShopListView(title: "인기 매장", shops: homeViewModel.popularShops)
                    BorderView()
                    HomeGameCardHScrollView(title: "흥미진진 신규게임", games: homeViewModel.newGames)
                    HomeGameCategoryHScrollView(title: "종류별 Best", categoryNames: ["마피아","블러핑","가족게임","전략"])
                    HomeShopListView(title: "신규 매장", shops: homeViewModel.newShops)
                        .padding(.bottom, 50)
                }
                .navigationDestination(for: Shop.self) { shop in
                    ShopDetailView(shop: shop)
                }
                .navigationDestination(for: Game.self) { game in
                    GameDetailView(path: $path, game: game)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
