//
//  MulitController.swift
//  gambler
//
//  Created by cha_nyeong on 3/25/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI

class MultiController {
    static let controller = MultiController()
    
    let searchController: MultiSearchController
    let shopHitsController: HitsObservableController<Hit<Shop>>
    let gameHitsController: HitsObservableController<Hit<Game>>
    let searchBoxController: SearchBoxObservableController
    let shopStatsController: StatsTextObservableController
    let gameStatsController: StatsTextObservableController
    
    
    init() {
        searchController = MultiSearchController()
        shopHitsController = HitsObservableController()
        gameHitsController = HitsObservableController()
        searchBoxController = SearchBoxObservableController()
        shopStatsController = StatsTextObservableController()
        gameStatsController = StatsTextObservableController()
        searchController.searchBoxConnector.connectController(searchBoxController)
        searchController.gameHitsConnector
            .connectController(gameHitsController)
        searchController.shopHitsConnector
            .connectController(shopHitsController)
        searchController.shopStatsConnector.interactor.connectController(shopStatsController) { stats -> String? in
            guard let stats = stats else {
              return nil
            }
            return "\(stats.totalHitsCount)"
          }
        searchController.gameStatsConnector.interactor.connectController(gameStatsController) { stats -> String? in
            guard let stats = stats else {
              return nil
            }
            return "\(stats.totalHitsCount)"
          }
    }
}
