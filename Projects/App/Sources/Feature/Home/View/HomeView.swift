//
//  HomeView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Logo")
                    EventBannerView()
                    HomeGamesGridView(title: "인기 게임", games: homeViewModel.popularGames)
                    HomeShopListView(title: "인기 매장", shops: homeViewModel.popularShops)
                    HomeGamesGridView(title: "신규 게임", games: homeViewModel.newGames)
                    HomeShopListView(title: "신규 매장", shops: homeViewModel.newShops)
                }
                .padding()
            }
        }
        // MARK: 개발 시 쓸모없는 데이터 호출을 막기 위해 firestore fetch 대신 더미데이터 사용하기 위한 주석 처리
//        .task {
//            await homeViewModel.fetchData()
//        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
