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
    
    static let dummyReview = Review(
        id: UUID().uuidString, 
        postId: "123",
        userId: "321",
        reviewContent: "조와요",
        reviewRating: 4.9,
        reviewImage: ["https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg"],
        createdDate: Date())
}
