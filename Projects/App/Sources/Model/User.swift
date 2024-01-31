//
//  User.swift
//  gambler
//
//  Created by 박성훈 on 1/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct User {
    let id: String = UUID().uuidString
    var nickname: String
    var profileImageURL: String?
    var apsToken: String?
    var createdDate: Date = Date()
    var likeGameIds: [String] = []
    var likeShopIds: [String] = []
}
