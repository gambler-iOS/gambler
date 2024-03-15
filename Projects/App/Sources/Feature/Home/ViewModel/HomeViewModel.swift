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
 
    private let firebaseManager = FirebaseManager.shared
    
    init() {
//        generateDummyData()
    }

    func generateDummyData() {
        popularGames = Game.dummyGameList
        popularShops = Shop.dummyShopList
        newGames = Game.dummyGameList
        newShops = Shop.dummyShopList
    }
}
