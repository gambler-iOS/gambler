//
//  GameCellView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/7/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameCellView: View {
    let game: Game

    var body: some View {
        VStack(alignment: .leading) {
            if let url = URL(string: game.gameImage) {
                KFImage(url)
                    .resizable()
                    .frame(width: 155, height: 155)
                    .scaledToFit()
                    .roundedCorner(15, corners: .allCorners)
                    .padding(.bottom, 8)
            }
            Text(game.gameName)
                .font(.title3)
                .foregroundStyle(.black)
                .padding(.vertical, 8)
            HStack {
                Image(systemName: "star.fill")
                Text(String(format: "%.1f", game.reviewRatingAverage))
                Text("인원 \(game.gameIntroduction.minPlayerCount) - \(game.gameIntroduction.maxPlayerCount)명")
                    .foregroundStyle(.gray)
            }
            .foregroundStyle(.red)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    GameCellView(game: Game(id: UUID().uuidString, gameName: "game", gameImage: "imagePath",
                      gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2,
                                                         maxPlayerCount: 4, playTime: 2,
                                                         genre: .fantasy),
                      descriptionImage: ["image"], gameLink: "link", createdDate: Date(),
                      reviewCount: 5, reviewRatingAverage: 3.5))
}
