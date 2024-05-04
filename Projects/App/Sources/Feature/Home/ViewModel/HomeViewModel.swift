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
    @Published var popularGenre: [GameGenre] = []
    @Published var isLoading: Bool = false
 
    private let firebaseManager = FirebaseManager.shared
    
    init() {
//        generateDummyData()
    }

    private func generateDummyData() {
        popularGames = Game.dummyGameList
        popularShops = Shop.dummyShopList
        newGames = Game.dummyGameList
        newShops = Shop.dummyShopList
    }
    
    @MainActor
    func fetchData() async {
        isLoading = true
        popularGames.removeAll()
        popularShops.removeAll()
        newGames.removeAll()
        newShops.removeAll()

        do {
            popularGames = try await firebaseManager
                .fetchOrderData(collectionName: AppConstants.CollectionName.games, orderBy: "reviewCount", limit: 4)
            popularShops = try await firebaseManager
                .fetchOrderData(collectionName: AppConstants.CollectionName.shops, orderBy: "reviewCount", limit: 3)
            newGames = try await firebaseManager
                .fetchOrderData(collectionName: AppConstants.CollectionName.games, orderBy: "createdDate", limit: 4)
            newShops = try await firebaseManager
                .fetchOrderData(collectionName: AppConstants.CollectionName.shops, orderBy: "createdDate", limit: 3)
            popularGenre = getPopularGenre()
        } catch {
            print("Error fetching HomeviewModel : \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func getPopularGenre() -> [GameGenre] {
        return Array(Set(popularGames.flatMap { game in
            game.gameIntroduction.genre
        }))
    }
}
