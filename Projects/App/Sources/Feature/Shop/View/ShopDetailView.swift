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
    let shop: Shop

    var body: some View {
        ScrollView {
            if let shop = shopDetailViewModel.shop {
                Text(shop.id)
                Text(shop.shopName)
                HomeShopListView(path: $path, title: "추천 매장", shops: homeViewModel.popularShops)
                // TODO: 프로토콜 형식으로 넘길 때 binding 걸 수 있을까? reviewView 에서 이전 shop 데이터 가지고 있는 문제 있음
                // ReviewView(postData: shop)
            } else {
                Text("매장 정보 없음")
            }
        }
        .onAppear {
            Task {
                print("=== fetch shopDetailViewModel ==")
                await shopDetailViewModel.fetchOneData(byId: shop.id)
            }
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
                              shopImage: "image", location: GeoPoint(latitude: 120.1, longitude: 140),
                              shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                              openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage"],
                              createdDate: Date(), reviewCount: 3,
                              reviewRatingAverage: 3.5))
}
