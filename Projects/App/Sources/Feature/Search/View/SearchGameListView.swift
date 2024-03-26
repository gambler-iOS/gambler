//
//  SearchGameListView.swift
//  gambler
//
//  Created by cha_nyeong on 3/26/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct SearchGameListView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @ObservedObject var gameViewModel:  PaginatedDataViewModel<AlgoliaHitsPage<Hit<Game>>>
    
    var body: some View {
        VStack {
            InfiniteList(gameViewModel) { game in
                GameListItemView(game: game.object, likeGameIdArray: [])
                    .onTapGesture {
                        appNavigationPath.searchViewPath.append(game.object)
                    }
            } noResults: {
                Text("No Results")
            }
            .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24))
        }
        .navigationTitle("게임 검색 결과")
        .modifier(BackButton())
    }
}


