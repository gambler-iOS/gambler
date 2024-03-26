//
//  MultiSearchController.swift
//  gambler
//
//  Created by cha_nyeong on 3/25/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI

class MultiSearchController {
    let multiSearcher: MultiSearcher
    let shopHitsConnector: HitsConnector<Hit<Shop>>
    let gameHitsConnector: HitsConnector<Hit<Game>>
    
    let shopStatsConnector: StatsConnector
    let gameStatsConnector: StatsConnector
    
    let searchBoxConnector: SearchBoxConnector
    
    init(searchTriggeringMode: SearchTriggeringMode = .searchOnSubmit) {
        multiSearcher = .init(client: .multiSearch)
        let shopSearcher = multiSearcher.addHitsSearcher(indexName: .shops)
        let gameSearcher = multiSearcher.addHitsSearcher(indexName: .games)
        searchBoxConnector = .init(searcher: multiSearcher,
                                   searchTriggeringMode: searchTriggeringMode)
        
        shopHitsConnector = .init(searcher: shopSearcher)
        gameHitsConnector = .init(searcher: gameSearcher)
        
        shopStatsConnector = .init(searcher: shopSearcher)
        gameStatsConnector = .init(searcher: gameSearcher)
        
        multiSearcher.search()
    }
}
