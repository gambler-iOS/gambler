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
    @Published var query: String = ""
    @Published var shopResult: [Shop] = [Shop.dummyShop,Shop.dummyShop]
    @Published var gameResult: [Game] = [Game.dummyGame,Game.dummyGame,Game.dummyGame]
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
//    init(searchService: SearchServiceProtocol = SearchService()) {
//        self.searchService = searchService
//    }
    
    func search() {
        isLoading = true
//        searchService.search(query: query) { [weak self] result in
//            self?.isLoading = false
//            switch result {
//            case .success(let results):
//                self?.results = results
//            case .failure(let error):
//                self?.error = error
//            }
//        }
    }
}
