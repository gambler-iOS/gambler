//
//  ShopCellView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/7/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ShopCellView: View {
    let shop: Shop

    var body: some View {
        VStack {
            HStack(spacing: 12) {
                if let url = URL(string: shop.shopImage) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                        .roundedCorner(15, corners: .allCorners)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(shop.shopName)")
                            .font(.title3)
                        Spacer()
                        // TODO: user data 읽어서 찜 되어있으면 색 바꾸는 기능 만들어야 함
                        Image(systemName: "heart.fill")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 4)
                    Text("강남역에서 엄청 가깝고 시설도")
                        .foregroundStyle(.gray)
                        .padding(.bottom, 4)
                    HStack {
                        Image(systemName: "star.fill")
                        Text(String(format: "%.1f", shop.reviewRatingAverage))
                    }
                    .foregroundStyle(.red)
                }
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    ShopCellView(shop: Shop(id: UUID().uuidString, shopName: "레드버튼 강남점", shopAddress: "address",
                            shopImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
                            location: GeoPoint(latitude: 120.1, longitude: 140),
                            shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                            openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage"],
                            createdDate: Date(), reviewCount: 3,
                            reviewRatingAverage: 3.5))
}
