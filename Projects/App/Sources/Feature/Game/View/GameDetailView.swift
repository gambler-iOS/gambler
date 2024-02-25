//
//  GameDetailView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameDetailView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var gameDetailViewModel: GameDetailViewModel
    let game: Game
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text(game.gameName)
                
                /// 게임 상세 정보
                GameDetailInfoView(game: game)
                
                BorderView()
                
                /// 리뷰 스크롤뷰
                GameDetailReviewHScorllView()
                
                BorderView()
                
                GameSimilarHScrollView(title: "비슷한 장르 게임", games: gameDetailViewModel.similarGenreGames)
                
                BorderView()
                
                GameSimilarHScrollView(title: "비슷한 인원수의 게임", games: gameDetailViewModel.similarPlayerGames)
            }
        }
        .onAppear {
            setGameInViewModel()
        }
        //        .toolbar {
        //            ToolbarItem(placement: .navigationBarTrailing) {
        //                Button("Back to List") {
        //                    path = NavigationPath()
        //                }
        //            }
        //        }
    }
    
    private func setGameInViewModel() {
        DispatchQueue.main.async {
            gameDetailViewModel.game = game
        }
    }

    @ViewBuilder
    func headerView(title: String, reviewInfo: String? = nil, navigationPath: @escaping () -> Void) -> some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(.subHead1B)
                .foregroundStyle(.black)
            
            if let reviewInfo {
                Text(reviewInfo)
                    .font(.body1B)
                    .foregroundStyle(.black)
                    .padding(.leading, 8)
            }
            
            Spacer()
            
            GamblerAsset.arrowRight.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    navigationPath()
                }
        }
    }
}

#Preview {
    GameDetailView(game: Game.dummyGame)
        .environmentObject(AppNavigationPath())
        .environmentObject(GameDetailViewModel())
}
