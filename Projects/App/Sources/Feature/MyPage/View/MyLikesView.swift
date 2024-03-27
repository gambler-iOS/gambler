//
//  MyLikesView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct MyLikesView: View {
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @EnvironmentObject private var tabSelection: TabSelection

    @State private var selectedFilter = AppConstants.MyPageFilter.allCases.first ?? .shop
    @State private var showHomeView: Bool = false
    
    var body: some View {
        VStack(spacing: 6) {
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
        .modifier(BackButton())
    }
    
    @ViewBuilder
    private func shopListView(shops: [Shop]) -> some View {
        if shops.isEmpty {
            emptyView(category: "매장")
        } else {
            ScrollView {
                VStack(spacing: 24) {
                    Rectangle()
                        .frame(height: 0)
                        .padding(.bottom, 0)
                    
                    ForEach(shops) { shop in
                        ShopListCellView(shop: shop, likeShopIdArray: [])
                        
                        if shop != shops.last {
                            Divider()
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    private func gameGridView(games: [Game]) -> some View {
        let columns: [GridItem] = Array(repeating:
                    .init(.flexible(minimum: 124, maximum: 200),
                          spacing: 17, alignment: .leading), count: 2)
        
        if games.isEmpty {
            emptyView(category: "게임")
        } else {
            ScrollView {
                VStack(spacing: 24) {
                    Rectangle()
                        .frame(height: 0)
                        .padding(.bottom, 0)
                    
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(games) { game in
                            GameGridItemView(game: game, likeGameIdArray: [])
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    private func emptyView(category: String) -> some View {
        VStack(spacing: 32) {
            Spacer()
            Text("좋아하는 \(category)을 추가해보세요!")
            
            CTAButton(disabled: .constant(false), title: "홈으로 가기") {
                tabSelection.goToHomeTab()
            }
            .frame(width: 180)

            Spacer()
        }
    }
}

#Preview {
    MyLikesView()
        .environmentObject(MyPageViewModel())
        .environmentObject(TabSelection())
}
