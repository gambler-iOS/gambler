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
}
