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
    @State private var selectedFilter = AppConstants.MyPageFilter.allCases.first ?? .shop
    @State private var showShopView: Bool = false
    @State private var showGameView: Bool = false
    
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
            VStack(spacing: 32) {
                Spacer()
                Text("좋아하는 매장을 추가해보세요!")
                
                CTAButton(disabled: .constant(false), title: "매장 보러가기") {
                    // 링크 걸기
                    showShopView.toggle()
                }
                .frame(width: 180)
                .navigationDestination(isPresented: $showShopView) {
                    HomeShopListView(title: "인기 매장", shops: [Shop.dummyShop])
                        .modifier(BackButton())
                }
                Spacer()
            }
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
            VStack(spacing: 32) {
                Spacer()
                Text("좋아하는 게임을 추가해보세요!")
                CTAButton(disabled: .constant(false), title: "게임 보러가기") {
                    // 링크 걸기
                    showGameView.toggle()
                }
                .frame(width: 180)
                .navigationDestination(isPresented: $showGameView) {
                    HomeGameGridView(title: "인기 게임", games: HomeViewModel().popularGames)
                        .modifier(BackButton())
                }
                Spacer()
            }
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
}

#Preview {
    MyLikesView()
        .environmentObject(MyPageViewModel())
}
