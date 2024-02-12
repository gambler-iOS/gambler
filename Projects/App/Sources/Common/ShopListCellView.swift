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
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(shop.shopName)")
                            .font(.body1M)
                            .foregroundStyle(Color.gray700)
                        
                        Spacer()
                        
                        HeartCellView(isLike: isLike)
                    }

                    HStack(spacing: 4) {
                        Group {
                            GamblerAsset.star.swiftUIImage
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 18, height: 18)
                            
                            Text(String(format: "%.1f", shop.reviewRatingAverage))
                                .padding(.trailing, 4)
                        }
                        .font(.caption1M)
                        .foregroundStyle(Color.primaryDefault)
                    }
                }
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    ShopListCellView(shop: Shop(id: UUID().uuidString, shopName: "레드버튼 강남점", shopAddress: "address",
                            shopImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
                            location: GeoPoint(latitude: 120.1, longitude: 140),
                            shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                            openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage"],
                            createdDate: Date(), reviewCount: 3,
                                reviewRatingAverage: 3.5), likeShopIdArray: [])
}
