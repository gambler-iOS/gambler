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
            similarGenreGames.append(
                Game(id: UUID().uuidString, gameName: "game\(num)",
                     gameImage: "https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186",
                     descriptionImage: ["https://boardm5.godohosting.com/goods/2024/02/dt01.png"],
                     gameLink: "link\(num)", createdDate: Date(),
                     reviewCount: 1 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num)),
                     gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2 + num,
                                                        maxPlayerCount: 4 + num, playTime: 2 + num,
                                                        genre: .fantasy)))
            similarPlayerGames.append(
                Game(id: UUID().uuidString, gameName: "game1\(num)",
                     gameImage: "https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186",
                     descriptionImage: ["https://boardm5.godohosting.com/goods/2024/02/dt01.png"],
                     gameLink: "link\(num)", createdDate: Date(),
                     reviewCount: 1 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num)),
                     gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2 + num,
                                                        maxPlayerCount: 4 + num, playTime: 2 + num,
                                                        genre: .fantasy)))
        }
    }
}
