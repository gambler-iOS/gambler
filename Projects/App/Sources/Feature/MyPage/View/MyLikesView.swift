//
//  MyLikesView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct MyLikesView: View {
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    @State private var selectedFilter = AppConstants.MyPageFilter.allCases.first ?? .shop
    
    var body: some View {
        VStack(spacing: 8) {
            SegmentTabView<AppConstants.MyPageFilter>(selectedFilter: self.$selectedFilter)
                .padding(.top, 24)
            
            switch selectedFilter {
            case .shop:
                shopListView(shops: myPageViewModel.likeShops)
            case .game:
                gameGridView(games: myPageViewModel.likeGames)
            }
        }
        .navigationTitle("좋아요")
    }
    
    @ViewBuilder
    private func shopListView(shops: [Shop]) -> some View {
        ScrollView {
            ForEach(shops) { shop in
                // NavigationLink(value: shop) {
                ShopListCellView(shop: shop, likeShopIdArray: [])
                // }
                    .padding(.top, 24)
                    .padding(.bottom)
                
                if shop != shops.last {
                    Divider()
                }
            }
        }
        .padding(.horizontal, 24)
        .scrollIndicators(.hidden)
        
    }
    
    @ViewBuilder
    private func gameGridView(games: [Game]) -> some View {
        
        let columns: [GridItem] = Array(repeating:
                .init(.fixed((UIScreen.main.bounds.width - 48) / 2),
                      spacing: 17, alignment: .center), count: 2)
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(games) { game in
                    // NavigationLink(value: game) {
                    GameGridItemView(game: game, likeGameIdArray: [])
                    // }
                        .padding(.top, 24)
                }
            }
        }
        .padding(.horizontal, 24)
        .scrollIndicators(.hidden)
        
    }
}

#Preview {
    MyLikesView()
        .environmentObject(MyPageViewModel())
}
