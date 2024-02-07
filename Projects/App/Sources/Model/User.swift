//
//  User.swift
//  gambler
//
//  Created by 박성훈 on 2/6/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct User: AvailableFirebase {
    let id: String
    var nickname: String
    var profileImageURL: String?
    var appsToken: String
    let createdDate: Date
    var likeGameId: [String]
    var likeShopId: [String]
    
//    init?(document: [String: Any]) {
//           guard
//               let id = document["id"] as? String,
//               let nickname = document["nickname"] as? String,
//               let profileImageURL = document["profileImageURL"] as? String,
//               let appsToken = document["appsToken"] as? String,
//               let createdDate = document["createdDate"] as? Date,
//               let likeGameId = document["likeGameId"] as? [String],
//               let likeShopId = document["likeShopId"] as? [String]
//           else {
//               return nil // 필수 필드가 없을 경우 초기화를 실패시킵니다.
//           }
//      
//        self.id = id
//        self.nickname = nickname
//        self.profileImageURL = profileImageURL
//        self.appsToken = appsToken
//        self.createdDate = createdDate
//        self.likeGameId = likeGameId
//        self.likeShopId = likeShopId
//    }
//    
//    init() {
//        self.nickname = ""
//        self.profileImageURL = ""
//        self.appsToken = ""
//        self.createdDate = Date()
//        self.likeGameId = []
//        self.likeShopId = []
//    }
//    
////    static func == (lhs: User, rhs: User) -> Bool {
////        return lhs.nickname == rhs.nickname
////    }
//    
//    func toDictionary() -> [String: Any] {
//           return [
//                   "nickname": nickname,
//                   "profileImageURL": profileImageURL,
//                   "appsToken": appsToken,
//                   "createdDate": createdDate,
//                   "likeGameId": likeGameId,
//                   "likeShopId": likeShopId
//                  ]
//       }
    
}
