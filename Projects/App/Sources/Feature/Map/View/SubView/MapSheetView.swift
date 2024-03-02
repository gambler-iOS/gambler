//
//  MapSheetView.swift
//  gambler
//
//  Created by daye on 2/26/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct MapSheetView: View {
    @ObservedObject var shopStore: ShopStore
    
    var body: some View {
        VStack {
            Text("내 주변")
                .bold()
                .padding()
            if shopStore.userAreaShopList.isEmpty {
                Text("없음")
            } else {
                ForEach(shopStore.userAreaShopList) { i in
                    Text("\(i.shopName)")
                }
            }
        }
    }
}

#Preview {
    MapSheetView(shopStore: ShopStore())
}