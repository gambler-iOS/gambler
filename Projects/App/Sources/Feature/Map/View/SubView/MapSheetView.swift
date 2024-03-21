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
            if mapViewModel.areaInShopList.isEmpty {
                Text("주변에 매장이 존재하지 않아요!")
            } else {
                ScrollView {
                    VStack {
                        ForEach(mapViewModel.areaInShopList) { shop in
                            NavigationLink(value: shop) {
                                ShopListCellView(shop: shop, likeShopIdArray: [])
                                    .padding(.horizontal, 24)
                            }
                            Divider()
                                .padding(.vertical, 24)
                        }
                       
                    }.padding(.vertical, 24)
                }
            }
        }
        .task {
            await mapViewModel.fetchUserAreaShopList(userPoint: userLocate)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    MapSheetView(mapViewModel: MapViewModel(), userLocate: .constant(GeoPoint(latitude: 0.0, longitude: 0.0)))
}
