//
//  SearchTestView.swift
//  gambler
//
//  Created by cha_nyeong on 3/25/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct SearchTestView: View {
    @ObservedObject var searchBoxController: SearchBoxObservableController
    @ObservedObject var shopHitsController: HitsObservableController<Hit<Shop>>
    @ObservedObject var gameHitsController: HitsObservableController<Hit<Game>>
    
    var body: some View {
        let shopHitsCount = shopHitsController.hits.count
        let gameHitsCount = gameHitsController.hits.count
        if shopHitsCount == 0 {
            SectionHeaderView(title: "매장", count: 0)
        } else {
            SectionHeaderView(title: "매장", count: shopHitsCount)
            LazyVStack {
                ForEach(0..<shopHitsCount, id: \.self) { index in
                    if let shop = shopHitsController.hits[index] {
                        ShopListCellView(shop: shop.object, likeShopIdArray: [])
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
        BorderView()
            .padding(.top, 32)
        
        if gameHitsCount == 0 {
            SectionHeaderView(title: "게임", count: 0)
        } else {
            SectionHeaderView(title: "게임", count: gameHitsCount)
            LazyVStack {
                ForEach(0..<gameHitsCount, id: \.self) { index in
                    if let game = gameHitsController.hits[index] {
                        GameListItemView(game: game.object, likeGameIdArray: [])
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}
