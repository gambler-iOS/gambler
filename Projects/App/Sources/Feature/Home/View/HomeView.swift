//
//  HomeView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @ObservedObject private var eventBannerViewModel: EventBannerViewModel = EventBannerViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Logo")
                    EventBannerView(eventBannerViewModel: eventBannerViewModel)
                    HomeGamesGridView(title: "인기 게임", games: homeViewModel.popularGames)
                    HomeShopListView(path: $path, title: "인기 매장", shops: homeViewModel.popularShops)
                    HomeGamesGridView(title: "신규 게임", games: homeViewModel.newGames)
                    HomeShopListView(path: $path, title: "신규 매장", shops: homeViewModel.newShops)
                }
                .padding()
                .navigationDestination(for: Shop.self) { shop in
                    ShopDetailView(path: $path, shop: shop)
                }
            }
        }
        // MARK: 개발 시 쓸모없는 데이터 호출을 막기 위해 firestore fetch 대신 더미데이터 사용하기 위한 주석 처리
//        .task {
//            print(" == fetch homeviewModel == ")
//            await eventBannerViewModel.fetchData()
//            await homeViewModel.fetchData()
//        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
