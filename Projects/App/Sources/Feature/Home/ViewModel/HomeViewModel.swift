//
//  HomeViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var shops: [Shop] = []

    private let firebaseManager = FirebaseManager.shared

    // TODO: test 코드로 옮길 예정
    func testCreate() async {
        do {
            for num in 1...5 {
                try firebaseManager.createData(collectionName: "Games", data: Game(id: UUID().uuidString, gameName: "game\(num)", gamelmage: "imagePath",
                                      gameIntroduction: GameIntroduction(difficulty: 3.1, minPlayerCount: 2 + num, maxPlayerCount: 4 + num, playTime: 2 + num, genre: .fantasy),
                                      descriptionimage: ["image\(num)"], gameLink: "link\(num)", createdDate: Date(), reviewCount: 1 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num))))
                try firebaseManager.createData(collectionName: "Shops",
                                               data: Shop(id: UUID().uuidString, shopName: "shop\(num)", shopAddress: "address\(num)", shopimage: "image\(num)",
                                                          location: GeoPoint(latitude: 120.1, longitude: 140), shopPhoneNumber: "010-5555", notice: "notice",
                                                          menu: ["커피": 1000], openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage\(num)"], createdDate: Date(),
                                                          creator: "creator\(num)", reviewCount: 3 + num, reviewRatingAverage: 3.5 + (0.1 * Double(num))))
            }
        } catch {
            print("\(error)")
        }
    }

    // TODO: 정렬된 데이터 한 번에 가져오는 것이 좋을까?
    func fetchData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.firebaseManager.fetchAllData(collectionName: "Games",
                                                        objectType: Game.self) { [weak self] data in
                    self?.games = data
                }
            }
            group.addTask {
                await self.firebaseManager.fetchAllData(collectionName: "Shops",
                                                        objectType: Game.self) { [weak self] data in
                    self?.games = data
                }
            }
//            group.async {
//                await fetchCollectionData(collectionName: "posts", objectType: Post.self) { [weak self] data in
//                    self?.posts = data
//                }
//            }
        }
    }
}
