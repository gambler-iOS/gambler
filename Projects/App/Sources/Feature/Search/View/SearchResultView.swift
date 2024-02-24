//
//  SearchResultView.swift
//  gambler
//
//  Created by cha_nyeong on 2/20/24.
//  Copyright © 2024 gambler. All rights reserved.
//  검색 결과 시 출력 될 뷰

import SwiftUI

struct SearchResultView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        if viewModel.shopResult.isEmpty {
            SectionHeaderView(title: "매장", count: 0)
        } else {
            SectionHeaderView(title: "매장", count: viewModel.shopResult.count)
            ForEach(viewModel.shopResult) { shop in
                ShopListCellView(shop: shop, likeShopIdArray: [])
                    .padding(.horizontal, 24)
            }
        }
        BorderView()
            .padding(.top, 32)
        
        if viewModel.gameResult.isEmpty {
            SectionHeaderView(title: "게임", count: 0)
        } else {
            SectionHeaderView(title: "게임", count: viewModel.gameResult.count)
            ForEach(viewModel.gameResult) { game in
                GameListItemView(game: game, likeGameIdArray: [])
                    .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    SearchResultView(viewModel: SearchViewModel())
}
