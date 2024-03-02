//
//  ShopListCellView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/11/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ShopListCellView: View {
    let shop: Shop
    let likeShopIdArray: [String]
    
    var isLike: Bool {
        likeShopIdArray.contains { id in
            id == shop.id
        }
    }
    
    var body: some View {
        VStack {
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
                    HStack {
                        Text("\(shop.shopName)")
                            .font(.body1M)
                            .foregroundStyle(Color.gray700)
                        
                        Spacer()
                        
                        HeartCellView(isLike: isLike)
                    }

                    ReviewRatingCellView(rating: shop.reviewRatingAverage)
                    
                    TagLayout {
                        ChipView(label: "👥 3 - 10명", size: .small)
                        ChipView(label: "🕛 10분 내외", size: .small)
                        ChipView(label: "📖 마피아", size: .small)
                        ChipView(label: "🟡 난이도 하", size: .small)
                    }
                    
                    HStack {
                        
                    }
                }
                .foregroundStyle(.black)
            }
            .frame(height: 100)
        }
    }
}

#Preview {
    ShopListCellView(shop: Shop.dummyShop, likeShopIdArray: [])
}
