//
//  FloatingCellView.swift
//  gambler
//
//  Created by daye on 2/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct FloatingCellView: View {
    let shop: Shop
    let likeShopIdArray: [String]
    
    var isLike: Bool {
        likeShopIdArray.contains { id in
            id == shop.id
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                if let url = URL(string: shop.shopImage) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                        .scaledToFit()
                } else {
                    RoundedRectangle(cornerRadius: 8.0)
                        .frame(width: 100, height: 100)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    HStack {
                        Text("\(shop.shopName)")
                            .font(.body1M)
                            .foregroundStyle(Color.gray700)
                        
                        Spacer()
                        
                        HeartCellView(isLike: isLike)
                    }
                    
                    ReviewRatingCellView(rating: shop.reviewRatingAverage)
                    Text("\(shop.shopAddress)")
                        .font(.body2M)
                        .foregroundStyle(Color.gray400)
                        .frame(height: 42, alignment: .top)
                      
                    Spacer()
                    
                }
                .foregroundStyle(.black)
            }
            .frame(height: 100)
        }
    }
}

#Preview {
    FloatingCellView(shop: Shop.dummyShop, likeShopIdArray: ["1"])
}
