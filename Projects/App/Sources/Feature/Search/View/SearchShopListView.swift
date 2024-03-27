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
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @ObservedObject var shopViewModel: PaginatedDataViewModel<AlgoliaHitsPage<Hit<Shop>>>
    
    var body: some View {
        VStack {
            InfiniteList(shopViewModel) { shop in
                ShopListCellView(shop: shop.object)
                    .onTapGesture {
                        appNavigationPath.searchViewPath.append(shop.object)
                    }
            } noResults: {
                Text("No Results")
            }
            .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24))
        }
        .navigationTitle("매장 검색 결과")
        .modifier(BackButton())
    }
}
