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
            if title.contains("장르") {
                NavigationLink(value: games.first?.gameIntroduction.genre.first) {
                    headerView(title: title, showGrid: false)
                        .padding(.trailing, 24)
                }
            } else if title.contains("인원수") {
                NavigationLink(value: games.first?.gameIntroduction.maxPlayerCount) {
                    headerView(title: title, showGrid: false)
                        .padding(.trailing, 24)
                }
            }
            
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
    
    @ViewBuilder
    private func headerView(title: String, showGrid: Bool) -> some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(.subHead1B)
                .foregroundStyle(.black)
            
            Spacer()
            
            GamblerAsset.arrowRight.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    GameSimilarHScrollView(title: "비슷한 장르 게임", games: [])
        .environmentObject(AppNavigationPath())
}
