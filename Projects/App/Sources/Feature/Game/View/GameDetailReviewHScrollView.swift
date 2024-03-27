//
//  GameDetailReviewHScorllView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct GameDetailReviewHScrollView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var gameDetailViewModel: GameDetailViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @State private var isNavigation: Bool = false
    private var game: Game {
        gameDetailViewModel.game
    }
    
    private var formattedReviewRatingAverage: String {
        if game.reviewRatingAverage == 0 {
            return "0"
        } else {
            return String(format: "%.1f", game.reviewRatingAverage)
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            DetailSectionHeaderView(title: "리뷰",
                                    reviewInfo: "\(formattedReviewRatingAverage)(\(game.reviewCount))") {
                guard loginViewModel.currentUser != nil else {
                    appNavigationPath.homeViewPath.append("로그인")
                    return
                }
                isNavigation = true
            }
            .padding(.trailing, 24)
            .navigationDestination(isPresented: $isNavigation) {
                ReviewDetailView(reviewableItem: game)
            }
            
            if game.reviewCount != 0 {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(gameDetailViewModel.reviews) { review in
                            ReviewListCellView(review: review)
                        }
                    }
                }
            } else {
                VStack {
                    Text("첫 번째 리뷰를 남겨주세요!")
                        .font(.body2M)
                        .foregroundStyle(Color.gray400)
                }
                .frame(height: 114)
                .frame(maxWidth: .infinity)
                .padding(.trailing, 24)
            }
        }
        .padding(.leading, 24)
    }
}

#Preview {
    GameDetailReviewHScrollView()
        .environmentObject(AppNavigationPath())
        .environmentObject(GameDetailViewModel())
}
