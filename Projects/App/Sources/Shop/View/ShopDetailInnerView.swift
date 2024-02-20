//
//  ShopDetailInnerView.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopDetailInnerView: View {
    var shop: Shop
    var review: Review?
    
    var body: some View {
        VStack(spacing: 0) {
            BorderView()
            ShopDetailInfoView(shop: shop)
                .padding(.vertical, 19)
                .padding(.horizontal, 24)
            BorderView()
        }
    }
}

#Preview {
    ShopDetailInnerView(shop: Shop.dummyShop)
}
