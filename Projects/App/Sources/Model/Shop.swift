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
    let shopCountry: String
    let shopPhoneNumber: String
    var cost: [String: Int]?
    var menu: [String: Int]?
    var openingHour: [String]?
    var amenity: [String]?
    var shopDetailImage: [String]?
    let createdDate: Date
    // 목록 호출 시 지나친 데이터 호출 막고, 보다 쉽게 리스트 출력하기 위해 추가
    var reviewCount: Int = 0
    var reviewRatingAverage: Double = 0.0
    
    var shopImages: [ImageItem]? {
        var resultArr: [ImageItem] = []
        guard let shopDetailImage, !shopDetailImage.isEmpty else { return resultArr }
        for img in shopDetailImage {
            resultArr.append(.init(image: img))
        }
        return resultArr
    }
    
    static let dummyShop = Shop(
        id: UUID().uuidString,
        shopName: "레드버튼 강남점",
        shopAddress: "서울특별시 강남구 역삼동 814-5 1층",
        shopImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
        location: GeoPoint(latitude: 120.1, longitude: 140), 
        shopCountry: "서욽특별시 삼성동",
        shopPhoneNumber: "010-5555",
        cost: nil,
        menu: ["커피": 1000, "이용금액(1시간)": 3000],
        openingHour: ["월요일: 휴무일","화요일: 오후 1:00~11:00","수요일: 오후 1:00~11:00","목요일: 오후 1:00~11:00","금요일: 오후 1:00 ~ 오전 12:00","토요일: 오후 1:00 ~ 오전 12:00","일요일: 오후 1:00~11:00"],
        amenity: ["주차"],
        shopDetailImage: [
            "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
            "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
            "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg"
        ],
        createdDate: Date(),
        reviewCount: 3,
        reviewRatingAverage: 3.5)
    
}

struct GeoPoint: Codable, Hashable {
    var latitude: Double
    var longitude: Double
    
    static let defaultPoint = GeoPoint(latitude: 37.402001, longitude: 127.108678)
}

/// Picture Model
struct ImageItem: Identifiable, Codable {
    var id: UUID = .init()
    var image: String
}

/// map dummy
extension Shop {
    static let dummyShopList = [
        Shop(id: UUID().uuidString, shopName: "레드버튼 판교점", shopAddress: "판교주소",
             shopImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
             location: GeoPoint(latitude: 37.395815438352216, longitude: 127.1122214051127), 
             shopCountry: "경기도 성남시",
             shopPhoneNumber: "010-1111",
             menu: ["커피": 1000],
             openingHour: ["10시"],
             amenity: ["주차"],
             shopDetailImage: [
                "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
                "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
                "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg"],
             createdDate: Date(),
             reviewCount: 3,
             reviewRatingAverage: 3.5),
        Shop(id: UUID().uuidString, shopName: "레드버튼 판교 2점", shopAddress: "2번째 판교",
             shopImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
             location: GeoPoint(latitude: 37.39568857499883, longitude: 127.11297786474694), 
             shopCountry: "경기도 성남시",
             shopPhoneNumber: "010-2222", 
             menu: ["커피": 1000],
             amenity: ["주차"],
             shopDetailImage: ["detailImage"],
             createdDate: Date(),
             reviewCount: 3,
             reviewRatingAverage: 3.5),
        Shop(id: UUID().uuidString, shopName: "레드버튼 판교 3점", shopAddress: "3번째 판교",
             shopImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
             location: GeoPoint(latitude: 37.395889599947324, longitude: 127.11000802973668),
             shopCountry: "경기도 성남시",
             shopPhoneNumber: "010-2222", menu: ["커피": 1000],
             openingHour: ["10시"],
             amenity: ["주차"],
             shopDetailImage: ["detailImage"],
             createdDate: Date(),
             reviewCount: 3,
             reviewRatingAverage: 3.5)
    ]
}
