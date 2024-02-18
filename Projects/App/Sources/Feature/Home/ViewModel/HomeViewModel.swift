//
//  HomeViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var popularGames: [Game] = []
    @Published var popularShops: [Shop] = []
    @Published var newGames: [Game] = []
    @Published var newShops: [Shop] = []
 
    init() {
        generateDummyData()
    }

    func generateDummyData() {
        let gameImageUrl: String =
        "https://boardm.co.kr/upload/product/img4/img_largeupfilenm_1689313043_0.jpg?t=1682590618"
        let shopImageUrl: String =
        "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20201122_151%2F1606046564169SzUUi_JPEG%2FrkjG5CgJbjULKNT0NaPHKoHl.jpg"
        for num in 1...3 {
            popularGames.append(Game(id: UUID().uuidString, gameName: "game\(num)", gameImage: gameImageUrl,
                                     descriptionImage: ["image\(num)"], gameLink: "link\(num)", createdDate: Date(),
                                     reviewCount: 1 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num)),
                                     gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2 + num,
                                                                        maxPlayerCount: 4 + num, playTime: 2 + num,
                                                                        genre: .fantasy)))
            popularShops.append(Shop(id: UUID().uuidString, shopName: "shop\(num)", shopAddress: "address\(num)",
                                     shopImage: shopImageUrl, location: GeoPoint(latitude: 120.1, longitude: 140),
                                     shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                                     openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage\(num)"],
                                     createdDate: Date(), reviewCount: 3 + num,
                                     reviewRatingAverage: 3.5 + (0.1 * Double(num))))
            newGames.append(Game(id: UUID().uuidString, gameName: "game\(num)", gameImage: gameImageUrl,
                                 descriptionImage: ["image\(num)"], gameLink: "link\(num)", createdDate: Date(),
                                 reviewCount: 1 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num)),
                                 gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2 + num,
                                                                    maxPlayerCount: 4 + num, playTime: 2 + num,
                                                                    genre: .fantasy)))
            newShops.append(Shop(id: UUID().uuidString, shopName: "shop\(num)", shopAddress: "address\(num)",
                                     shopImage: shopImageUrl, location: GeoPoint(latitude: 120.1, longitude: 140),
                                     shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                                     openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage\(num)"],
                                     createdDate: Date(), reviewCount: 4 + num,
                                     reviewRatingAverage: 3.5 + (0.1 * Double(num))))
        }
    }
}
