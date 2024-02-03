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
    
    var body: some View {
        VStack(alignment: .leading){
            BoldDivider()
            ShopDetailInfo(shop: shop)
            BoldDivider()
            SummaryReviewView()
            BoldDivider()
           
        }
    }
    
    private struct BoldDivider: View {
        var body: some View {
            Rectangle()
                .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                .frame(height: 5)
        }
    }
}

#Preview {
    ShopDetailInnerView()
}
