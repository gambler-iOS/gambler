//
//  Shop.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Shop: AvailableFirebase {
    var id: String
    let shopName: String
    // TODO: 지도에서 호출할 지역 정렬을 위해 분리해야 할 듯
    let shopAddress: String
    let shopimage: String
    let location: GeoPoint
    let shopPhoneNumber: String
    let notice: String
    let menu: [String: Int]
    let openingHour: String
    let amenity: [String]
    let shopDetailImage: [String]
    let createdDate: Date
    let creator: String
    // 목록 호출 시 지나친 데이터 호출 막고, 보다 쉽게 리스트 출력하기 위해 추가
    var reviewCount: Int
    var reviewRatingAverage: Double
}

struct GeoPoint: Codable {
    var latitude: Double
    var longitude: Double
}
