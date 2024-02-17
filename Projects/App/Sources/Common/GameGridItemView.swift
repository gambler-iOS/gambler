//
//  GameGridItemView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/11/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameGridItemView: View {
    let game: Game
    let likeGameIdArray: [String]
    
    var playerString: String {
        "인원 \(game.gameIntroduction.minPlayerCount)~\(game.gameIntroduction.maxPlayerCount)명"
    }
    
    var isLike: Bool {
        likeGameIdArray.contains { id in
            id == game.id
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let url = URL(string: game.gameImage) {
                KFImage(url)
                    .resizable()
                    .frame(width: 155, height: 155)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .scaledToFit()
                    .padding(.bottom, 8)
                    .overlay(alignment: .topTrailing) {
                        HeartCellView(isLike: isLike)
                        .padding(8)
                    }
            } else {
                RoundedRectangle(cornerRadius: 8.0)
                    .frame(width: 155, height: 155)
                    .padding(.bottom, 8)
            }
            
            Text(game.gameName)
                .font(.body1M)
                .foregroundStyle(Color.gray700)
            
            HStack(spacing: 8) {
                ReviewRatingCellView(rating: game.reviewRatingAverage)
                
                Text(playerString)
                    .foregroundStyle(Color.gray400)
                    .font(.caption1M)
            }
        }
    }
}

#Preview {
    GameGridItemView(game: Game.dummyGame, likeGameIdArray: [])
}
