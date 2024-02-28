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
    var profileImageURL: String
    var apnsToken: String?
    let createdDate: Date
    #warning("옵셔널로 바꾸기")
    var likeGameId: [String]
    #warning("옵셔널로 바꾸기")
    var likeShopId: [String]
    var myReviewsCount: Int
    var myLikesCount: Int
    #warning("enum 처리 추가")
    //var social: Social
    
    static let dummyUser: User = User(
        id: UUID().uuidString,
        nickname: "성훈",
        profileImageURL: "https://cdn-icons-png.flaticon.com/512/21/21104.png",
        apnsToken: "카카오톡",
        createdDate: Date(),
        likeGameId: [],
        likeShopId: [],
        myReviewsCount: 12,
        myLikesCount: 5
    )
}
