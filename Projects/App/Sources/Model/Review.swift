//
//  Review.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Review: FirebaseAvailable {
    var id: String
    let postld: String
    let userld: String
    var reviewContent: String
    var reviewRating: Int
    var reviewlmage: [String]?
    let createdDate: Date
}
