//
//  GameDetailViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class GameDetailViewModel: ObservableObject {
    @Published var game: Game = Game.dummyGame
    @Published var reviews: [Review] = []
    @Published var similarGenreGames: [Game] = []
    @Published var similarPlayerGames: [Game] = []
    
    private let firebaseManager = FirebaseManager.shared
    
    init() {
//        generateDummyData()
    }
    
    private func generateDummyData() {
        similarGenreGames = Game.dummyGameList
        similarPlayerGames = Game.dummyGameList
        reviews.append(Review.dummyGameReview)
        reviews.append(Review.dummyGameReview)
    }
    
    @MainActor
    func fetchSimilarGameData() async {
        similarGenreGames.removeAll()
        similarPlayerGames.removeAll()
        
        do {
            similarGenreGames = try await firebaseManager
                .fetchWhereArrayContainsData(collectionName: AppConstants.CollectionName.games,
                                             field: "gameIntroduction.genre",
                                             arrayContainsAny: game.gameIntroduction.genre.map { $0.rawValue },
                                             limit: 6)
            
            similarPlayerGames = try await firebaseManager
                .fetchWhereIsEqualToData(collectionName: AppConstants.CollectionName.games,
                                         field: "gameIntroduction.maxPlayerCount",
                                         isEqualTo: game.gameIntroduction.maxPlayerCount,
                                         limit: 6)
        } catch {
            print("Error fetchSimilarGameData() GameDetailViewModel : \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchReviewData() async {
        do {
            reviews = try await firebaseManager
                .fetchWhereIsEqualToData(collectionName: AppConstants.CollectionName.reviews,
                                         field: "postId",
                                         isEqualTo: game.id,
                                         orderBy: "createdDate",
                                         limit: 3)
        } catch {
            print("Error fetchReviewData() GameDetailViewModel : \(error.localizedDescription)")
        }
    }

    /// review 작성 시 game.reviewCount, game.reviewRatingAverage 정보 수정
    @MainActor
    func updateGameAggregateReview(appendReviewRating: Double) async {
        var calcRatingAvg = (Double(game.reviewCount) * game.reviewRatingAverage) + appendReviewRating
        calcRatingAvg /= Double(game.reviewCount + 1)
        
        let data: [AnyHashable: Any] = [
            "reviewCount": (game.reviewCount + 1),
            "reviewRatingAverage": (calcRatingAvg)
        ]

        do {
            try await firebaseManager.updateData(collectionName: "Games", byId: game.id, data: data)
            game.reviewCount += 1
            game.reviewRatingAverage = calcRatingAvg
        } catch {
            print("Error updateGameAggregateReview() GameDetailViewModel : \(error.localizedDescription)")
        }
    }
    
    /// review 작성 후 게임 모델 내 리뷰 관련 데이터 업데이트된 내용 화면에 다시 출력하기 위해 사용
    @MainActor
    func fetchGameInfo() async {
        do {
            if let data: Game = try await firebaseManager
                .fetchOneData(collectionName: AppConstants.CollectionName.games, byId: game.id) {
                
                game = data
            }
        } catch {
            print("Error fetchGameInfo() GameDetailViewModel : \(error.localizedDescription)")
        }
    }
}
