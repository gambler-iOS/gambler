//
//  Algolia + Extension.swift
//  gambler
//
//  Created by cha_nyeong on 3/25/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import AlgoliaSearchClient
import Foundation

extension SearchClient {
  static let multiSearch = Self(appID: "T9PDR9Q3NM", apiKey: "0055a81493d2ad46aedfb117245685af")
}

extension IndexName {
  static let shops: IndexName = "shop_index"
  static let games: IndexName = "game_index"
}
