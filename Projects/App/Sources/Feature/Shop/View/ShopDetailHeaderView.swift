//
//  ShopDetailHeaderView.swift
//  gambler
//
//  Created by cha_nyeong on 3/5/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopDetailHeaderView: View {
    let shop: Shop
    
    var body: some View {
        HStack(spacing: .zero) {
            Text("리뷰")
                .font(.subHead1B)
                .foregroundStyle(Color.gray700)
            if shop.reviewCount != 0 {
                Text("\(roundAndTrimDouble(shop.reviewRatingAverage))(\(shop.reviewCount))")
                    .font(.body1B)
                    .foregroundStyle(Color.primaryDefault)
                    .padding(.leading, 8)
            } else {
                Text("0.0(0)")
            }
            
            Spacer()
            
            GamblerAsset.arrowRight.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
    
    func roundAndTrimDouble(_ value: Double) -> String {
        let roundedValue = String(format: "%.1f", value)
        return roundedValue.replacingOccurrences(of: ".0", with: "")
    }

}
#Preview {
    ShopDetailHeaderView(shop: .dummyShop)
}
