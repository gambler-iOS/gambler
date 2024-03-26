//
//  SearchShopListView.swift
//  gambler
//
//  Created by cha_nyeong on 3/26/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct SearchShopListView: View {
    @ObservedObject var shopViewModel:  PaginatedDataViewModel<AlgoliaHitsPage<Hit<Shop>>>
    
    var body: some View {
        InfiniteList(shopViewModel) { shop in
            ShopListCellView(shop: shop.object, likeShopIdArray: [])
        } noResults: {
            Text("No Results")
        }
    }
}
