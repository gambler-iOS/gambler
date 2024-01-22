//
//  Game.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Game: AvailableFirebase {
    var id: String
    let gameName: String
    let gamelmage: String
    let gameIntroduction: GameIntroduction
    var descriptionimage: [String]
    var gameLink: String
    let createdDate: Date
    var reviewCount: Int
    var reviewRatingAverage: Double
}

struct GameIntroduction: Codable {
    let difficulty: Double
    let minPlayerCount: Int
    let maxPlayerCount: Int
    let playTime: Int
    let genre: Genre
}

enum Genre: String, Codable {
    case fantasy
}
