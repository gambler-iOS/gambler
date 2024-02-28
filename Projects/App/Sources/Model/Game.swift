//
//  Game.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Game: AvailableFirebase, AvailableAggregateReview, Hashable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }

    var id: String
    let gameName: String
    let gameImage: String
    var descriptionImage: [String]
    var gameLink: String
    let createdDate: Date
    var reviewCount: Int
    var reviewRatingAverage: Double
    let gameIntroduction: GameIntroduction
    
    static let dummyGame = Game(
        id: UUID().uuidString,
        gameName: "아임 더 보스",
        gameImage: "https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186",
        descriptionImage: [
            "https://boardm5.godohosting.com/goods/2024/02/dt01.png"],
        gameLink: "link",
        createdDate: Date(),
        reviewCount: 5,
        reviewRatingAverage: 3.5,
        gameIntroduction: GameIntroduction(
            difficulty: 3.1,
            minPlayerCount: 2,
            maxPlayerCount: 4,
            playTime: 2,
            genre: .fantasy)
        )
}

struct GameIntroduction: Codable, Hashable {
    let difficulty: Double
    let minPlayerCount: Int
    let maxPlayerCount: Int
    let playTime: Int
    let genre: Genre
}

enum Genre: String, Codable {
    case fantasy
}
