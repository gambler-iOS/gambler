//
//  GameDetailReviewHScorllView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct GameDetailReviewHScorllView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var gameDetailViewModel: GameDetailViewModel
    private var game: Game {
        gameDetailViewModel.game
    }
    
    var body: some View {
        VStack(spacing: 24) {
            DetailSectionHeaderView(title: "리뷰", reviewInfo: "\(game.reviewRatingAverage)(\(game.reviewCount))") {
                appNavigationPath.homeViewPath.append("리뷰")
            }
            .padding(.trailing, 24)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(gameDetailViewModel.reviews) { review in
                        ReviewListCellView(review: review)
                            .frame(width: 254)
                    }
                }
            }
        }
        .padding(.leading, 24)
    }
}

#Preview {
    GameDetailReviewHScorllView()
        .environmentObject(AppNavigationPath())
        .environmentObject(GameDetailViewModel())
}
