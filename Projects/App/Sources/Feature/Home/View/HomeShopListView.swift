//
//  HomeShopListView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeShopListView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var loginViewModel: LoginViewModel
    let title: String
    var shops: [Shop]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SectionHeaderView(title: title)
                    .onTapGesture {
                        appNavigationPath.homeViewPath.append(title)
                    }
                
                ForEach(shops) { shop in
                    NavigationLink(value: shop) {
                        ShopListCellView(shop: shop)
                    }
                    if shop != shops.last {
                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeShopListView(title: "인기 매장", shops: [Shop.dummyShop])
}
