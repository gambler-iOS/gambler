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
    }
    
    @MainActor
    func fetchData() async {
        similarGenreGames.removeAll()
        similarPlayerGames.removeAll()
        
        do {
            reviews = try await firebaseManager
                .fetchWhereIsEqualToData(collectionName: AppConstants.CollectionName.reviews,
                                         field: "postId",
                                         isEqualTo: game.id,
                                         limit: 3)
            
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
            print("Error fetching GameDetailViewModel : \(error.localizedDescription)")
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
            print("Error fetching GameInfo GameDetailViewModel : \(error.localizedDescription)")
        }
    }
}
