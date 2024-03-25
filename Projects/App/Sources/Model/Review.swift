//
//  Review.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

enum ReviewCategory: Codable {
    case shop
    case game
    
    var path: String {
        switch self {
        case .shop:
            return "Shops"
        case .game:
            return "Games"
        }
    }
}

struct Review: AvailableFirebase, Hashable {
    var id: String
    let postId: String
    let userId: String
    var reviewContent: String
    var reviewRating: Double
    var reviewImage: [String]?
    let createdDate: Date
    let category: ReviewCategory
    
    static let dummyShopReview: Review = Review(id: UUID().uuidString,
                                                postId: UUID().uuidString,
                                                userId: UUID().uuidString,
                                                reviewContent: "강남역에서 엄청 가깝고 시설도 좋더라구요~ 게임도 많아서 오랫동안 있었네요! 알바생도 친절해서 좋았어요, 다음에도 선릉점으로 가려구요",
                                                reviewRating: 4.5,
                                                reviewImage: ["https://beziergames.com/cdn/shop/products/UltimateAccessoryPack_800x.png?v=1587055236"],
                                                createdDate: Date(),
                                                category: .shop
    )
    
    static let dummyGameReview: Review = Review(id: UUID().uuidString,
                                                postId: UUID().uuidString,
                                                userId: UUID().uuidString,
                                                reviewContent: "친구 3명이랑 했는데 일반 마피아보다 색달라서 재밌었어요. 쉬운 게임이여서 진입장벽 없이 바로 할 수 있음요 ~!",
                                                reviewRating: 4.0,
                                                reviewImage: ["https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186"],
                                                createdDate: Date(),
                                                category: .game
    )
}
