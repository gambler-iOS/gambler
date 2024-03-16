//
//  SearchViewModel.swift
//  gambler
//
//  Created by cha_nyeong on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    private let shopCollectionName = AppConstants.CollectionName.shops
    private let GameCollectionName = AppConstants.CollectionName.games
    
    @Published var query: String = ""
    @Published var shopResult: [Shop] = []
    @Published var gameResult: [Game] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
//    init(searchService: SearchServiceProtocol = SearchService()) {
//        self.searchService = searchService
//    }
    
    //    func search() {
    //    isLoading = true
//        searchService.search(query: query) { [weak self] result in
//            self?.isLoading = false
//            switch result {
//            case .success(let results):
//                self?.results = results
//            case .failure(let error):
//                self?.error = error
//            }
//        }
  //  }
 
    func fetchData() async {
        var tempShop: [Shop] = []
        var tempGame: [Game] = []
        
        shopResult.removeAll()
        gameResult.removeAll()
        
        do {
            tempShop = try await firebaseManager.fetchAllData(collectionName: shopCollectionName)
        } catch {
            print("Error fetching \(shopCollectionName) : \(error.localizedDescription)")
        }
        
        do {
            tempGame = try await firebaseManager.fetchAllData(collectionName: GameCollectionName)
        } catch {
            print("Error fetching \(GameCollectionName) : \(error.localizedDescription)")
        }

        self.shopResult = tempShop
        self.gameResult = tempGame
        
    }
}
