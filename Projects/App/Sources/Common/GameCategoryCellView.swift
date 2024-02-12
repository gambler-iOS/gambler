//
//  GameCategoryCellView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/11/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameCategoryCellView: View {
    let game: Game

    var body: some View {
        VStack(spacing: 16) {
            if let url = URL(string: game.gameImage) {
                KFImage(url)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .scaledToFit()
                    .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 80, height: 80)
            }
            
            Text(game.gameName)
                .font(.body2M)
                .foregroundStyle(Color.gray700)
        }
    }
}

#Preview {
    GameCategoryCellView(game: Game(id: UUID().uuidString, gameName: "아임더보스",
                                    gameImage: "https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186",
                                    gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2,
                                                                       maxPlayerCount: 4, playTime: 2,
                                                                       genre: .fantasy),
                                    descriptionImage: ["image"], gameLink: "link", createdDate: Date(),
                                    reviewCount: 5, reviewRatingAverage: 3.5))
}
