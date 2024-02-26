//
//  GameDetailView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

/*
// https://github.com/danielsaidi/ScrollKit
public struct ScrollViewHeader<Content: View>: View {

    /**
     Create a stretchable scroll view header.
     */
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }

    private let content: () -> Content

    public var body: some View {
        GeometryReader { geo in
            content()
                .stretchable(in: geo)
        }
    }
}

private extension View {

    @ViewBuilder
    func stretchable(in geo: GeometryProxy) -> some View {
        let width = geo.size.width
        let height = geo.size.height
        let minY = geo.frame(in: .global).minY
        let useStandard = minY <= 0
        self.frame(width: width, height: height + (useStandard ? 0 : minY))
            .offset(y: useStandard ? 0 : -minY)
    }
}
*/
struct GameDetailView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var gameDetailViewModel: GameDetailViewModel
    let game: Game
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                if let url = URL(string: game.gameImage) {
                    KFImage(url)
                        .resizable()
                        .overlay {
                            LinearGradient(gradient:
                                            Gradient(colors: [.clear, .black]),
                                           startPoint: UnitPoint(x: 0.5, y: 0.5), endPoint: .top)
                        }
                        .scaledToFill()
                        .frame(height: 290)
                        .background(Color.blue)
                }
                VStack(alignment: .leading, spacing: 32) {
                    HStack(alignment: .center, spacing: 8) {
                        Text(game.gameName)
                            .font(.subHead1B)
                        ReviewRatingCellView(rating: game.reviewRatingAverage)
                    }
                    .padding(.leading, 24)
                    .padding(.top, 32)
                    
                    HStack(alignment: .center, spacing: .zero) {
                        ItemButtonView(image: GamblerAsset.heartGray.swiftUIImage, buttonName: "찜하기") {
                            
                        }
                        
                        Spacer()
                        
                        ItemButtonView(image: GamblerAsset.review.swiftUIImage, buttonName: "리뷰") {
                            
                        }
                    }
                    .frame(height: 72)
                    .padding(EdgeInsets(top: -10, leading: 71, bottom: -32, trailing: 71))
                    
                    BorderView()
                    
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
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16.0))
            }
        }
        .onAppear {
            setGameInViewModel()
        }
        .ignoresSafeArea(.all, edges: .top)
//        .navigationTitle("\(game.gameName)")
//        .navigationBarTitleDisplayMode(.inline)
        .modifier(BackButton())
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
    NavigationStack {
        GameDetailView(game: Game.dummyGame)
            .environmentObject(AppNavigationPath())
            .environmentObject(GameDetailViewModel())
    }
}
