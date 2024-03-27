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
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var gameDetailViewModel: GameDetailViewModel
    @State private var offsetY: CGFloat = CGFloat.zero
    @State private var isWriteReviewButton: Bool = false
    @State private var isHeartButton: Bool = false
    @State private var isShowingToast: Bool = false
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
                    .padding([.horizontal, .bottom], 24)
                
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
            await gameDetailViewModel.fetchReviewData()
            await gameDetailViewModel.fetchSimilarGameData()
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationTitle(offsetY < -5 ? "\(game.gameName)" : "")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(BackButton())
        .buttonStyle(HiddenClickAnimationButtonStyle())
        .overlay {
            if isShowingToast {
                toastMessageView
            }
        }
    }
    
    private var toastMessageView: some View {
        CustomToastView(content: "리뷰 작성이 완료되었습니다!")
            .offset(y: UIScreen.main.bounds.height * 0.3)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isShowingToast = false
                    }
                }
            }
    }
    
    private func setGameInViewModel() {
        DispatchQueue.main.async {
            gameDetailViewModel.game = game
            if let curUser = loginViewModel.currentUser, let likeGameArray = curUser.likeGameId {
                if likeGameArray.contains(game.id) {
                    isHeartButton = true
                }
            }
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
            Text(gameDetailViewModel.game.gameName)
                .font(.subHead1B)
            ReviewRatingCellView(rating: gameDetailViewModel.game.reviewRatingAverage)
        }
    }
    
    private var gameItemButtonsView: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: .zero) {
                ItemButtonView(
                    image: isHeartButton == false ?
                    GamblerAsset.heartGray.swiftUIImage : GamblerAsset.heartRed.swiftUIImage,
                    buttonName: "찜하기") {
                        
                        updateLikeGameList()
                        isHeartButton = ((loginViewModel.currentUser?.likeGameId?.contains(game.id)) != nil)
                    }
                    .frame(width: geometry.size.width / 2)
                
                ItemButtonView(image: GamblerAsset.review.swiftUIImage, buttonName: "리뷰") {
                    guard loginViewModel.currentUser != nil else {
                        appNavigationPath.isGoTologin = true
                        return
                    }
                    isWriteReviewButton = true
                }
                .navigationDestination(isPresented: $isWriteReviewButton) {
                    WriteReviewView(isShowingToast: $isShowingToast, reviewableItem: game)
                }
                .frame(width: geometry.size.width / 2)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func updateLikeGameList() {
        guard var curUser = loginViewModel.currentUser else {
            appNavigationPath.isGoTologin = true
            return
        }
        
        var userLikeDictionary: [AnyHashable: Any] = [:]
        var updatedLikeArray: [String] = []
        
        if let likeGameIdArray = curUser.likeGameId {
            updatedLikeArray = likeGameIdArray
        }
        
        if isHeartButton {
            updatedLikeArray.append(game.id)
        } else {
            updatedLikeArray.removeAll { $0 == game.id }
        }
        
        loginViewModel.currentUser?.likeGameId = updatedLikeArray
        
        userLikeDictionary["likeGameId"] = updatedLikeArray
        
        Task {
            await loginViewModel.updateLikeList(likePostIds: userLikeDictionary)
        }
    }
}

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
            .environmentObject(LoginViewModel())
    }
}
