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
            HStack(alignment: .top, spacing: 16) {
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
                        VStack(alignment: .leading) {
                            Text("\(shop.shopName)")
                                .font(.body1M)
                                .foregroundStyle(Color.gray700)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                        Spacer()
                        
                        HeartCellView(isLike: isLike, postId: shop.id, postType: AppConstants.PostType.shop)
                    }

                    ReviewRatingCellView(rating: shop.reviewRatingAverage)
                    
                    Text("\(shop.shopAddress)")
                        .font(.body2M)
                        .foregroundStyle(Color.gray400)
                        .frame(height: 42)
                        .multilineTextAlignment(.leading)

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
