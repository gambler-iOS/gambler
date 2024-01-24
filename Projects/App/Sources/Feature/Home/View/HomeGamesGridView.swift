//
//  PopularGamesView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeGamesGridView: View {
    let title: String
    let games: [Game]

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            ForEach(games) { game in
                NavigationLink {
                    Text(game.gameName)
                } label: {
                    Text(game.gameName)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        @ObservedObject var homeViewModel = HomeViewModel()

        HomeGamesGridView(title: "인기 게임", games: homeViewModel.popularGames)
    }
}
