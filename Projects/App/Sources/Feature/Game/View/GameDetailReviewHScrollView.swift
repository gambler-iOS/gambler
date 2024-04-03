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
    @EnvironmentObject private var tabSelection: TabSelection
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
                    switch tabSelection.selectedTab {
                    case 0:
                        appNavigationPath.homeViewPath.append(true)
                    case 1:
                        appNavigationPath.mapViewPath.append(true)
                    case 2:
                        appNavigationPath.searchViewPath.append(true)
                    case 3:
                        appNavigationPath.myPageViewPath.append(true)
                    default:
                        appNavigationPath.isGoTologin = false
                    }
                    return
                }
                isNavigation = true
            }
            .navigationDestination(isPresented: $isNavigation) {
                ReviewDetailView(reviewableItem: game, targetName: game.gameName)
            }
            
            if game.reviewCount != 0 {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(gameDetailViewModel.reviews) { review in
                            ReviewListCellView(review: review)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            } else {
                VStack {
                    Text("첫 번째 리뷰를 남겨주세요!")
                        .font(.body2M)
                        .foregroundStyle(Color.gray400)
                }
                .frame(height: 114)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    GameDetailReviewHScrollView()
        .environmentObject(AppNavigationPath())
        .environmentObject(GameDetailViewModel())
}
