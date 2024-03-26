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
  let testController: MultiSearchController
  let shopHitsController: HitsObservableController<Hit<Shop>>
  let gameHitsController: HitsObservableController<Hit<Game>>
  let searchBoxController: SearchBoxObservableController
  let statsController: StatsTextObservableController
  let loadingController: LoadingObservableController

  init() {
      testController = MultiSearchController()
    hitsController = HitsObservableController()
    searchBoxController = SearchBoxObservableController()
    statsController = StatsTextObservableController()
    loadingController = LoadingObservableController()
    demoController.searchBoxConnector.connectController(searchBoxController)
    demoController.hitsInteractor.connectController(hitsController)
    demoController.searcher.search()
  }
}
