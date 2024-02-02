//
//  Shop.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Shop: AvailableFirebase, AvailableAggregateReview, Hashable {
    static func == (lhs: Shop, rhs: Shop) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String
    let shopName: String
    let shopAddress: String
    let shopImage: String
    let location: GeoPoint
    let shopPhoneNumber: String
    let menu: [String: Int]
    let openingHour: String
    let amenity: [String]
    let shopDetailImage: [String]
    let createdDate: Date
    // 목록 호출 시 지나친 데이터 호출 막고, 보다 쉽게 리스트 출력하기 위해 추가
    var reviewCount: Int
    var reviewRatingAverage: Double
}

struct GeoPoint: Codable, Hashable {
    var latitude: Double
    var longitude: Double
}
