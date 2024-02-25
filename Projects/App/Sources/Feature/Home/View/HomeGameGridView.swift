//
//  HomeGamesGridView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeGameGridView: View {
    let title: String
    let games: [Game]
    let columns: [GridItem] = Array(repeating:
            .init(.flexible(minimum: 124, maximum: 200),
                  spacing: 17, alignment: .leading), count: 2)

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeaderView(title: title)
            
            LazyVGrid(columns: columns, spacing: 24, content: {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameGridItemView(game: game, likeGameIdArray: [])
                    }
                }
            })
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeGameGridView(title: "인기 게임", games: HomeViewModel().popularGames)
}
