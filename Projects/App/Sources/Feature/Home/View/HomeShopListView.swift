//
//  PopularShopsView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeShopListView: View {
    let title: String
    var shops: [Shop]

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            ForEach(shops) { shop in
                NavigationLink {
                    Text(shop.shopName)
                } label: {
                    Text(shop.shopName)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeShopListView(title: "인기 매장", shops: [])
    }
}
