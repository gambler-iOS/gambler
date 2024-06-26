//
//  HomeGamesGridView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeGameGridView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var loginViewModel: LoginViewModel
    let title: String
    let games: [Game]
    private let columns: [GridItem] = Array(repeating:
            .init(.flexible(minimum: 124, maximum: 200), spacing: 17, alignment: .leading), count: 2)

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeaderView(title: title)
            .onTapGesture {
                appNavigationPath.homeViewPath.append(title)
            }
            
            LazyVGrid(columns: columns, spacing: 24, content: {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameGridItemView(game: game)
                    }
                }
            })
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeGameGridView(title: "인기 게임", games: HomeViewModel().popularGames)
        .environmentObject(AppNavigationPath())
}
