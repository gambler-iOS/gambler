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
    @State private var offsetY: CGFloat = CGFloat.zero
    @State private var isWriteReviewButton: Bool = false
    @State private var isHeartButton: Bool = false
    private let headerImageHeight: CGFloat = 290
    let game: Game
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                setOffset(offset: offset)
                if let url = URL(string: game.gameImage) {
                    KFImage(url)
                        .resizable()
                        .overlay {
                            LinearGradient(gradient:
                                            Gradient(colors: [.clear, .black]),
                                           startPoint: UnitPoint(x: 0.5, y: 0.5), endPoint: .top)
                        }
                        .scaledToFill()
                        .clipped()
                        .frame(
                            width: geometry.size.width,
                            height: headerImageHeight + (offset > 0 ? offset : 0)
                        )
                        .offset(y: (offset > 0 ? -offset : 0))
                }
                RoundCornerView
                    .offset(y: headerImageHeight - 20)
            }
            .frame(minHeight: headerImageHeight)
            
            VStack(alignment: .leading, spacing: 32) {
                titleView
                    .padding(.horizontal, 24)
                
                gameItemButtonsView
                    .frame(height: 72)
                    .padding(EdgeInsets(top: -10, leading: 71, bottom: -32, trailing: 71))
                
                BorderView()
                
                /// 게임 상세 정보
                GameDetailInfoView(game: game)
                
                BorderView()
                
                /// 리뷰 스크롤뷰
                GameDetailReviewHScrollView()
                
                BorderView()
                
                GameSimilarHScrollView(title: "비슷한 장르 게임", games: gameDetailViewModel.similarGenreGames)
                
                BorderView()
                
                GameSimilarHScrollView(title: "비슷한 인원수의 게임", games: gameDetailViewModel.similarPlayerGames)
            }
            .background(Color.white)
        }
        .onAppear {
            setGameInViewModel()
        }
        .task {
            await gameDetailViewModel.fetchData()
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationTitle(offsetY < -5 ? "\(game.gameName)" : "")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(BackButton())
    }
    
    private func setGameInViewModel() {
        DispatchQueue.main.async {
            gameDetailViewModel.game = game
        }
    }
    
    private func setOffset(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            self.offsetY = offset
        }
        return EmptyView()
    }
    
    private var RoundCornerView: some View {
        Rectangle()
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width, height: 40)
            .clipShape(TempRoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
    }
    
    private var titleView: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(game.gameName)
                .font(.subHead1B)
            ReviewRatingCellView(rating: gameDetailViewModel.game.reviewRatingAverage)
        }
    }
    
    private var gameItemButtonsView: some View {
        HStack(alignment: .center, spacing: .zero) {
            ItemButtonView(
                image: isHeartButton == false ?
                GamblerAsset.heartGray.swiftUIImage : GamblerAsset.heartRed.swiftUIImage,
                buttonName: "찜하기") {
                    
                    isHeartButton.toggle()
                    if isHeartButton {
                        /// 유저 데이터에 찜 등록
                    } else {
                        /// 유저 데이터에서 찜 삭제
                    }
                }
            
            Spacer()
            
            ItemButtonView(image: GamblerAsset.review.swiftUIImage, buttonName: "리뷰") {
                isWriteReviewButton = true
            }
            .navigationDestination(isPresented: $isWriteReviewButton) {
                WriteReviewView(reviewableItem: game)
            }
        }
    }
}

/// 팀원이 공통뷰에 RoundedCorner 제작 중인데 PR 이 아직 올라오지 않아 임시로 추가함.
private struct TempRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

#Preview {
    NavigationStack {
        GameDetailView(game: Game.dummyGame)
            .environmentObject(AppNavigationPath())
            .environmentObject(GameDetailViewModel())
    }
}
