//
//  GameListItemView.swift
//  gambler
//
//  Created by cha_nyeong on 2/14/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameListItemView: View {
    
    let game: Game
    let likeGameIdArray: [String]
    
    private var isLike: Bool {
        likeGameIdArray.contains { id in
            id == game.id
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: AppConstants.Padding.horizontal) {
                if let url = URL(string: game.gameImage) {
                    KFImage.url(url)
                        .resizable()
                        .frame(
                            width: AppConstants.ImageFrame.listCell.width,
                            height: AppConstants.ImageFrame.listCell.height)
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.CornerRadius.small))
                        .scaledToFit()
                } else {
                    RoundedRectangle(cornerRadius: AppConstants.CornerRadius.small)
                        .frame(
                            width: AppConstants.ImageFrame.listCell.width,
                            height: AppConstants.ImageFrame.listCell.height)
                        .foregroundColor(Color.gray200)
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(game.gameName)")
                            .font(.body1M)
                            .foregroundStyle(Color.gray700)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        HeartCellView(isLike: isLike, postId: game.id, postType: AppConstants.PostType.game)
                    }

                    ReviewRatingCellView(rating: game.reviewRatingAverage)
                    
                    TagLayout {
                        ForEach(game.chipViewLabel, id: \.self) { label in
                            ChipView(label: label, size: .small)
                        }
                    }
                    Spacer()
                }
                .foregroundStyle(.black)
            }
            .frame(height: 108)
        }
    }
}

#Preview {
    GameListItemView(game: Game.dummyGame, likeGameIdArray: [])
}
