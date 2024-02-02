//
//  HomeViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var popularGames: [Game] = []
    @Published var popularShops: [Shop] = []
    @Published var newGames: [Game] = []
    @Published var newShops: [Shop] = []

    private let firebaseManager = FirebaseManager.shared

    init() {
        generateDummyData()
    }

    func generateDummyData() {
        for num in 1...4 {
            popularGames.append(Game(id: UUID().uuidString, gameName: "game\(num)", gameImage: "imagePath",
                                     gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2 + num,
                                                                        maxPlayerCount: 4 + num, playTime: 2 + num,
                                                                        genre: .fantasy),
                                     descriptionImage: ["image\(num)"], gameLink: "link\(num)", createdDate: Date(),
                                     reviewCount: 1 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num))))
            popularShops.append(Shop(id: UUID().uuidString, shopName: "shop\(num)", shopAddress: "address\(num)",
                                     shopImage: "image\(num)", location: GeoPoint(latitude: 120.1, longitude: 140),
                                     shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                                     openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage\(num)"],
                                     createdDate: Date(), reviewCount: 3 + num,
                                     reviewRatingAverage: 3.5 + (0.1 * Double(num))))
            newGames.append(Game(id: UUID().uuidString, gameName: "game\(num)", gameImage: "imagePath",
                                     gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2 + num,
                                                                        maxPlayerCount: 4 + num, playTime: 2 + num,
                                                                        genre: .fantasy),
                                     descriptionImage: ["image\(num)"], gameLink: "link\(num)", createdDate: Date(),
                                     reviewCount: 1 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num))))
            newShops.append(Shop(id: UUID().uuidString, shopName: "shop\(num)", shopAddress: "address\(num)",
                                     shopImage: "image\(num)", location: GeoPoint(latitude: 120.1, longitude: 140),
                                     shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                                     openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage\(num)"],
                                     createdDate: Date(), reviewCount: 4 + num,
                                     reviewRatingAverage: 3.5 + (0.1 * Double(num))))
        }
    }

    // TODO: test 코드로 옮길 예정
    func testCreateData() async {
        do {
            for num in 1...5 {
                try firebaseManager.createData(
                    collectionName: "Games",
                    data: Game(id: UUID().uuidString, gameName: "game\(num)", gameImage: "imagePath",
                               gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2 + num,
                                                                  maxPlayerCount: 4 + num, playTime: 2 + num,
                                                                  genre: .fantasy),
                               descriptionImage: ["image\(num)"], gameLink: "link\(num)", createdDate: Date(),
                               reviewCount: 1 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num))))
                try firebaseManager.createData(
                    collectionName: "Shops",
                    data: Shop(id: UUID().uuidString, shopName: "shop\(num)", shopAddress: "address\(num)",
                               shopImage: "image\(num)", location: GeoPoint(latitude: 120.1, longitude: 140),
                               shopPhoneNumber: "010-5555", menu: ["커피": 1000], openingHour: "10시",
                               amenity: ["주차"], shopDetailImage: ["detailImage\(num)"], createdDate: Date(),
                               reviewCount: 3 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num))))
            }
        } catch {
            print("\(error)")
        }
    }

    @MainActor
    func fetchData() async {
        popularGames.removeAll()
        popularShops.removeAll()
        newGames.removeAll()
        newShops.removeAll()

        let popularGames = await firebaseManager.fetchOrderData(collectionName: "Games", objectType: Game.self,
                                             orderBy: "reviewCount", limit: 4)
        let popularShops = await firebaseManager.fetchOrderData(collectionName: "Shops", objectType: Shop.self,
                                             orderBy: "reviewCount", limit: 4)
        let newGames = await firebaseManager.fetchOrderData(collectionName: "Games", objectType: Game.self,
                                             orderBy: "createdDate", limit: 4)
        let newShops = await firebaseManager.fetchOrderData(collectionName: "Shops", objectType: Shop.self,
                                             orderBy: "createdDate", limit: 4)

        self.popularGames = popularGames
        self.popularShops = popularShops
        self.newGames = newGames
        self.newShops = newShops
    }
}
