//
//  GameListViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class GameListViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var showGrid: Bool = false
    
    init() {
        generateDummyData()
    }

    func generateDummyData() {
        let gameImageUrl: String =
        "https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186"
        for num in 1...5 {
            games.append(Game(id: UUID().uuidString, gameName: "game\(num)", gameImage: gameImageUrl,
                              descriptionImage: ["https://boardm5.godohosting.com/goods/2024/02/dt01.png"],
                              gameLink: "link\(num)", createdDate: Date(),
                              reviewCount: 1 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num)),
                              gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2 + num,
                                                                 maxPlayerCount: 4 + num, playTime: 2 + num,
                                                                 genre: .fantasy)))
        }
    }
}
