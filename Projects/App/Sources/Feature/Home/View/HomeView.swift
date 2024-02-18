//
//  HomeView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    HomeShopListView(title: "인기 매장", shops: homeViewModel.popularShops)
                    BorderView()
                    HomeShopListView(title: "신규 매장", shops: homeViewModel.newShops)
                }
                .navigationDestination(for: Shop.self) { shop in
                    ShopDetailView(shop: shop)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
