//
//  User.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct User: AvailableFirebase, Hashable {
    var id: String
    var nickname: String
    var profileImageURL: String
    var apnsToken: String?
    let createdDate: Date
    var likeGameId: [String]?
    var likeShopId: [String]?
    var myReviewsCount: Int
    var myLikesCount: Int
    var loginPlatform: LoginPlatform
    
    static let dummyUser: User = User(
        id: UUID().uuidString,
        nickname: "성훈",
        profileImageURL: "https://cdn-icons-png.flaticon.com/512/21/21104.png",
        apnsToken: "카카오톡",
        createdDate: Date(),
        likeGameId: [],
        likeShopId: [],
        myReviewsCount: 12,
        myLikesCount: 5, 
        loginPlatform: .kakakotalk
    )
}

enum LoginPlatform: Codable {
    case kakakotalk
    case apple
    case google
    case none
    
    var description: String {
        switch self {
        case .kakakotalk:
            return "카카오톡"
        case .apple:
            return "애플"
        case .google:
            return "구글"
        case .none:
            return "로그아웃"
        }
    }
}
