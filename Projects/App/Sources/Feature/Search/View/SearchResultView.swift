//
//  SearchResultView.swift
//  gambler
//
//  Created by cha_nyeong on 2/20/24.
//  Copyright © 2024 gambler. All rights reserved.
//  검색 결과 시 출력 될 뷰

import SwiftUI

struct SearchResultView: View {
    var filteredShops: [Shop]
    var filteredGames: [Game]
    
    var body: some View {
        if filteredShops.isEmpty && filteredGames.isEmpty {
            emptyResultView
                .padding(.horizontal, 24)
        } else {
            Group {
                SectionHeaderView(title: "매장", count: filteredShops.count)
                ForEach(filteredShops) { shop in
                    ShopListCellView(shop: shop, likeShopIdArray: [])
                    Divider()
                }
            } .padding(.horizontal, 24)
            
            BorderView()
                .padding(.top, 32)
            
            Group {
                SectionHeaderView(title: "게임", count: filteredGames.count)
                ForEach(filteredGames) { game in
                    GameListItemView(game: game, likeGameIdArray: [])
                    Divider()
                }
            } .padding(.horizontal, 24)
        }
    }
    
    private var emptyResultView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("검색 결과가 없습니다.")
                    .font(.subHead2M)
                Text("이런 검색어는 어떠세요?")
                    .font(.caption1M)
                    .foregroundStyle(Color.gray500)
                    .padding(.top, 8)
            }
            Spacer()
        }
    }
}

#Preview {
    SearchResultView(filteredShops: [Shop.dummyShop], filteredGames: [Game.dummyGame])
}
