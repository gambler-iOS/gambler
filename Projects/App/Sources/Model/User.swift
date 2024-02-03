//
//  User.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct User: AvailableFirebase {
    var id: String
    var nickname: String
    var profileImage: String
    var apnsToken: String
    let createdDate: Date
    var likeGameId: [String]
    var likeShopId: [String]
}
