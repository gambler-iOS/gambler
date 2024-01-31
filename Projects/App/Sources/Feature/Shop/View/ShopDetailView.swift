//
//  ShopDetailView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/31/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopDetailView: View {
    @EnvironmentObject private var shopDetailViewModel: ShopDetailViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel // test용
    @Binding var path: NavigationPath
    @State var shop: Shop

    var body: some View {
        ScrollView {
            Text(shop.shopName)

            HomeShopListView(path: $path, title: "추천 매장", shops: homeViewModel.popularShops)
        }
        .toolbar {
           ToolbarItem(placement: .navigationBarTrailing) {
              Button("Back to List") {
                 path = NavigationPath()
              }
           }
        }
    }
}

#Preview {
    ShopDetailView(path: .constant(NavigationPath()),
                   shop: Shop(id: UUID().uuidString, shopName: "shop", shopAddress: "address",
                              shopimage: "image", location: GeoPoint(latitude: 120.1, longitude: 140),
                              shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                              openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage"],
                              createdDate: Date(), reviewCount: 3,
                              reviewRatingAverage: 3.5))
}
