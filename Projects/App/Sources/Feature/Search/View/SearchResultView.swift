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

struct SearchResultView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
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
                    .onTapGesture {
                        appNavigationPath.searchViewPath.append("Shops")
                    }
                LazyVStack {
                    if shopHitsCount < 3 {
                        ForEach(0..<shopHitsCount, id: \.self) { index in
                            if let shop = shopHitsController.hits[index] {
                                ShopListCellView(shop: shop.object)
                                    .onTapGesture {
                                        appNavigationPath.searchViewPath.append(shop.object)
                                    }
                            }
                        }
                    } else {
                        ForEach(0..<3, id: \.self) { index in
                            if let shop = shopHitsController.hits[index] {
                                ShopListCellView(shop: shop.object)
                                    .onTapGesture {
                                        appNavigationPath.searchViewPath.append(shop.object)
                                    }
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
                    .onTapGesture {
                        appNavigationPath.searchViewPath.append("Games")
                    }
                LazyVStack {
                    if gameHitsCount < 3 {
                        ForEach(0..<gameHitsCount, id: \.self) { index in
                            if let game = gameHitsController.hits[index] {
                                GameListItemView(game: game.object)
                                    .onTapGesture {
                                        appNavigationPath.searchViewPath.append(game.object)
                                    }
                            }
                        }
                    } else {
                        ForEach(0..<3, id: \.self) { index in
                            if let game = gameHitsController.hits[index] {
                                GameListItemView(game: game.object)
                                    .onTapGesture {
                                        appNavigationPath.searchViewPath.append(game.object)
                                    }
                            }
                        }
                    }
                }
                .padding(.top, 24)
            }
            
            if shopHitsCount == 0 && gameHitsCount == 0 {
                Group {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("검색 결과가 없습니다.")
                                .font(.subHead2M)
                                .foregroundColor(Color.black)
                            Spacer()
                        }
                        HStack {
                            Text("다른 검색어를 입력해주세요~")
                                .font(.caption1M)
                                .foregroundColor(.gray500)
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                }
            }
        }
    }
}
