//
//  MapSheetView.swift
//  gambler
//
//  Created by daye on 2/26/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct MapSheetView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Binding var userLocate: GeoPoint
    
    var body: some View {
        VStack {
            Text("내 주변")
                .bold()
                .padding(20)
            ScrollView {
                if mapViewModel.areaInShopList.isEmpty {
                    Text("주변에 매장이 없어요.")
                } else {
                    VStack(spacing: 24) {
                        ForEach(mapViewModel.areaInShopList) { shop in
                            NavigationLink(value: shop) {
                                ShopListCellView(shop: shop, likeShopIdArray: [])
                            }
                            if shop != mapViewModel.areaInShopList.last {
                                Divider()
                            }
                        }
                    }.padding(.top, 24)
                        .padding(.horizontal, 24)
                }
            }
        }
        .task {
            let country = await mapViewModel.getCountry(mapPoint: userLocate)
            await mapViewModel.filterShopsByCountry(country: country)
        }
        .navigationDestination(for: Shop.self) { shop in
            ShopDetailInfoView(shop: shop)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    MapSheetView(mapViewModel: MapViewModel(), userLocate: .constant(GeoPoint(latitude: 0.0, longitude: 0.0)))
}
