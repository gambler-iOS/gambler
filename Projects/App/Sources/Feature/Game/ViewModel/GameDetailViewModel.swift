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
    
    init() {
        generateDummyData()
        game.reviewRatingAverage = 4.0
    }

    func generateDummyData() {
        for num in 1...3 {
            reviews.append(Review.dummyGameReview)
            similarGenreGames = Game.dummyGameList
            similarPlayerGames = Game.dummyGameList
        }
    }
}
