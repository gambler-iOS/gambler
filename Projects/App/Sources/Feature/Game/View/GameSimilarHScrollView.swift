//
//  GameSimilarHScrollView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct GameSimilarHScrollView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    let title: String
    let games: [Game]
    
    var body: some View {
        VStack(spacing: 24) {
            DetailSectionHeaderView(title: title) {
                appNavigationPath.homeViewPath.append(title)
            }
            .padding(.trailing, 24)
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(games) { game in
                        NavigationLink(value: game) {
                            GameMiniGridItemView(game: game)
                        }
                        .focusEffectDisabled()
                    }
                }
            }
        }
        .padding(.leading, 24)
    }
}

#Preview {
    GameSimilarHScrollView(title: "비슷한 장르 게임", games: [])
        .environmentObject(AppNavigationPath())
}
