//
//  PopularGamesView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeGamesGridView: View {
    let title: String?
    let games: [Game]
    let columns: [GridItem] = Array(repeating: .init(.fixed(155), spacing: 17, alignment: .leading), count: 2)

    var body: some View {
        VStack(alignment: .leading) {
            if let title {
                HStack {
                    Text(title)
                        .font(.title2)
                    Spacer()
                    NavigationLink {
                        Text("gameListView")
                    } label: {
                        Image(systemName: "greaterthan")
                            .foregroundStyle(.black)
                    }
                }
            }
            LazyVGrid(columns: columns, content: {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameCellView(game: game)
                    }
                }
            })
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        @ObservedObject var homeViewModel = HomeViewModel()

        HomeGamesGridView(title: "인기 게임", games: homeViewModel.popularGames)
    }
}
