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
                .padding(10)
            if shopStore.shopList.isEmpty {
                Text("없음")
            } else {
                ScrollView {
                    VStack {
                        ForEach(shopStore.shopList) { i in
                            Text("\(i.shopName)")
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    MapSheetView(shopStore: ShopStore())
}
