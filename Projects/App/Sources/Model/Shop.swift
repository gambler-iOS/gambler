//
//  Shop.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Shop: FirebaseAvailable {
    var id: String
    let shopName: String
    let shopAddress: String
    let shopimage: String
    let location: GeoPoint
    let shopPhoneNumber: String
    let notice: String
    let menu: [String: Int]
    let openingHour: String
    let amenity: [String]
    let shopDefaillmage: [String]
    let createdDate: Date
    let creater: String
}

struct GeoPoint: Codable {
    var latitude: Double
    var longitude: Double
}
