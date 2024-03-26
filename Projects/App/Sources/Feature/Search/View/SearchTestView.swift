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
    @ObservedObject var shopStatsController: StatsTextObservableController
    @ObservedObject var gameStatsController: StatsTextObservableController

    var body: some View {
        ScrollView {
            let shopHitsCount = shopHitsController.hits.count
            let gameHitsCount = gameHitsController.hits.count
            
            if shopHitsCount == 0 {
                EmptyView()
            } else {
                SectionHeaderView(title: "매장", count: Int(shopStatsController.stats))
                LazyVStack {
                    if shopHitsCount < 3 {
                        ForEach(0..<shopHitsCount, id: \.self) { index in
                            if let shop = shopHitsController.hits[index] {
                                ShopListCellView(shop: shop.object, likeShopIdArray: [])
                            }
                        }
                    } else {
                        ForEach(0..<3, id: \.self) { index in
                            if let shop = shopHitsController.hits[index] {
                                ShopListCellView(shop: shop.object, likeShopIdArray: [])
                            }
                        }
                    }
                }
                .padding(.top, 24)
            }
            if shopHitsCount != 0 && gameHitsCount != 0 {
                BorderView()
                    .padding(.top, 24)
            }
            
            if gameHitsCount == 0 {
                EmptyView()
            } else {
                SectionHeaderView(title: "게임", count: Int(gameStatsController.stats))
                LazyVStack {
                    if gameHitsCount < 3 {
                        ForEach(0..<gameHitsCount, id: \.self) { index in
                            if let game = gameHitsController.hits[index] {
                                GameListItemView(game: game.object, likeGameIdArray: [])
                            }
                        }
                    } else {
                        ForEach(0..<3, id: \.self) { index in
                            if let game = gameHitsController.hits[index] {
                                GameListItemView(game: game.object, likeGameIdArray: [])
                            }
                        }
                    }
                }
                .padding(.top, 24)
            }
            
            if shopHitsCount == 0 && gameHitsCount == 0 {
                
            }
        }
    }
}
