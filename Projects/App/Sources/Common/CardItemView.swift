//
//  CardItemView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/11/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct CardItemView: View {
    let game: Game
    private var playerString: String {
        "인원 \(game.gameIntroduction.minPlayerCount)~\(game.gameIntroduction.maxPlayerCount)명"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if let url = URL(string: game.gameImage) {
                KFImage(url)
                    .resizable()
                    .overlay {
                        LinearGradient(gradient: Gradient(colors: [.clear, .black]),
                                       startPoint: UnitPoint(x: 0.5, y: 0.33),
                                       endPoint: .bottom)
                    }
                    .frame(width: 240, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
                    .scaledToFit()
                    .overlay(alignment: .bottomLeading) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(game.gameName)
                                .font(.body1M)
                                .foregroundStyle(Color.gray50)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(width: 208, alignment: .leading)
                            
                            HStack(spacing: 8) {
                                ReviewRatingCellView(rating: game.reviewRatingAverage, textColor: .gray50)
                                
                                Text(playerString)
                                    .foregroundStyle(Color.gray50)
                                    .font(.caption1M)
                            }
                        }
                        .padding(.bottom, 16)
                        .padding(.leading, 16)
                    }
            } else {
                RoundedRectangle(cornerRadius: 16.0)
                    .frame(width: 240, height: 300)
            }
        }
    }
}

#Preview {
    CardItemView(game: Game.dummyGame)
}
