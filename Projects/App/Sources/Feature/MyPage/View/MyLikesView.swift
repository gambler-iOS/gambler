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
    
//    let columns: [GridItem] = Array(repeating:
//            .init(.flexible(minimum: 124, maximum: 200),  // 200
//                  spacing: 17, alignment: .leading), count: 2)
    
    var body: some View {
        VStack(spacing: 0) {
            SegmentTabView<AppConstants.MyPageFilter>(selectedFilter: self.$selectedFilter)
                .padding(.top, 24)
            
            switch selectedFilter {
            case .shop:
                shopListView(shops: myPageViewModel.likeShops)
            case .game:
                gameGridView(games: myPageViewModel.likeGames)
            }
        }
        .navigationTitle("나의 리뷰")
    }
    
    @ViewBuilder
    private func shopListView(shops: [Shop]) -> some View {
        List {
            Section {
                ForEach(shops) { shop in
                    //                NavigationLink(value: shop) {
                    ShopListCellView(shop: shop, likeShopIdArray: [])
                    //                }
                        .padding(.top, 24)
                }
            }
            .listSectionSeparator(.hidden, edges: .bottom)
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func gameGridView(games: [Game]) -> some View {

        let columns: [GridItem] = Array(repeating:
                .init(.flexible(minimum: 124, maximum: 200),
                      spacing: 17, alignment: .leading), count: 2)
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(games) { game in
                    
//                    NavigationLink(value: game) {
                    GameGridItemView(game: game, likeGameIdArray: [])
//                    }
                    .padding(.top, 24)
                }
            }
        }
        .padding(.leading, 24)
//        .scrollIndicators(.hidden)
//        .listStyle(.plain)
    }
}

#Preview {
    MyLikesView()
        .environmentObject(MyPageViewModel())
}
