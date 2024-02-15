//
//  Review.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Review: AvailableFirebase {
    var id: String
    let postId: String
    let userId: String
    var reviewContent: String
    var reviewRating: Double
    var reviewImage: [String]?
    let createdDate: Date
    
    static let dummyReview: Review = Review(id: UUID().uuidString,
                                            postId: UUID().uuidString,
                                            userId: UUID().uuidString,
                                            reviewContent: "강남역에서 엄청 가깝고 시설도 좋더라구요~ 게임도 많아서 오랫동안 있었네요! 알바생도 친절해서 좋았어요, 다음에도 선릉점으로 가려구요",
                                            reviewRating: 4.5,
                                            reviewImage: ["https://beziergames.com/cdn/shop/products/UltimateAccessoryPack_800x.png?v=1587055236"],
                                            createdDate: Date()
    )
}
