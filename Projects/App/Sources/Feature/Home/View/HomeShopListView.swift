//
//  PopularShopsView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeShopListView: View {
    @Binding var path: NavigationPath
    let title: String?
    var shops: [Shop]

    var body: some View {
        VStack(alignment: .leading) {
            if let title {
                HStack {
                    Text(title)
                        .font(.title2)
                    Spacer()
                    NavigationLink {
                        Text("shopListView")
                    } label: {
                        Image(systemName: "greaterthan")
                            .foregroundStyle(.black)
                    }
                }
            }
            ForEach(shops) { shop in
                NavigationLink(value: shop) {
                    ShopCellView(shop: shop)
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        HomeShopListView(path: .constant(NavigationPath()),
                         title: "인기 매장", shops: [])
    }
}
