//
//  ShopDetailInnerView.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopDetailInnerView: View {
    var shop: Shop?
    var review: Review?
    
    var body: some View {
        VStack(alignment: .leading){
            BoldDivider()
            ShopDetailInfo(shop: shop)
            BoldDivider()
            SummaryReviewView()
            BoldDivider()
            LocationMapView()
            
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    ShopDetailInnerView()
}
