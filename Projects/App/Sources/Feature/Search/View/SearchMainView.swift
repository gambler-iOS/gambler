//
//  SearchMainView.swift
//  gambler
//
//  Created by cha_nyeong on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import SwiftData
import InstantSearchCore
import InstantSearchSwiftUI

struct SearchMainView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @Environment(\.modelContext) private var modelContext
    @State private var isEditing = false
    @State private var isSearch = false
    @ObservedObject var searchBoxController: SearchBoxObservableController
    @ObservedObject var shopHitsController: HitsObservableController<Hit<Shop>>
    @ObservedObject var gameHitsController: HitsObservableController<Hit<Game>>
    @ObservedObject var shopStatsController: StatsTextObservableController
    @ObservedObject var gameStatsController: StatsTextObservableController
    
    var body: some View {
        NavigationStack(path: $appNavigationPath.searchViewPath) {
            ScrollView {
                VStack(spacing: 32) {
                    SearchBarView(searchText: $searchBoxController.query,
                                  isEditing: $isEditing, isSearch: $isSearch,
                                  onSubmit: searchBoxController.submit)
                    if isSearch {
                        SearchResultView(
                            searchBoxController: searchBoxController,
                            shopHitsController: shopHitsController,
                            gameHitsController: gameHitsController,
                            shopStatsController : shopStatsController, gameStatsController: gameStatsController
                        )
                    } else {
                        RecentKeywordView()
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .navigationDestination(for: String.self) { str in
                    if str == "Shops" {
                        SearchShopListView(shopViewModel:
                                            MultiController.controller.searchController.shopSearcher.paginatedData(of: Hit<Shop>.self))
                    } else if str == "Games" {
                        SearchGameListView(gameViewModel:
                                            MultiController.controller.searchController.gameSearcher.paginatedData(of: Hit<Game>.self))
                    }
                }
                .navigationDestination(for: Shop.self) { shop in
                    ShopDetailInfoView(shop: shop)
                }
                .navigationDestination(for: Game.self) { game in
                    GameDetailView(game: game)
                }
            }
        }
    }
    
}
