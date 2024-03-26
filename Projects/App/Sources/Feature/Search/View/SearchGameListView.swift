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
    @ObservedObject var gameViewModel:  PaginatedDataViewModel<AlgoliaHitsPage<Hit<Game>>>
    
    var body: some View {
        InfiniteList(gameViewModel) { game in
            GameListItemView(game: game.object, likeGameIdArray: [])
        } noResults: {
            Text("No Results")
        }
    }
}


