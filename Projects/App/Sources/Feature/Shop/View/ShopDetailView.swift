//
//  ShopDetailView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopDetailView: View {
    let shop: Shop
    
    var body: some View {
        VStack {
            #warning("ShopDetail 더미")
            Text(shop.shopName)
        }
    }
}

#Preview {
    ShopDetailView(shop: Shop.dummyShop)
}
