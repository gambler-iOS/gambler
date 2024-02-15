//
//  LocationMapView.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopDetailMapView: View {
    @State var draw: Bool = false
    var shop: Shop?
    var body: some View {
        VStack{
            HStack{
                Text("위치")
                    .font(.title3)
                    .bold()
                Spacer()
            }.padding(.bottom, 24)
            KakaoMapView(draw: $draw, userLatitude: .constant(10), userLongitude: .constant(10), isShowingSheet: .constant(false), isMainMap: false, detailMapPoint: shop?.location)
                .onAppear {
                    Task {
                        self.draw = true
                    }
                }
                .allowsHitTesting(false)
                .frame(width: 327, height: 215)
                .cornerRadius(8)
        }.padding(.horizontal, 24)
            .padding(.vertical, 32)
    }
}

#Preview {
    ShopDetailMapView(
                        shop: Shop(id: UUID().uuidString, shopName: "shop", shopAddress: "address",
                                   shopImage: "image", location: GeoPoint(latitude: 120.1, longitude: 140),
                                   shopPhoneNumber: "010-5555", menu: ["커피": 1000, "아이스티": 2000],
                                   openingHour: "10시", amenity: ["주차","담요","와이파이"], shopDetailImage: ["detailImage"],
                                   createdDate: Date(), reviewCount: 3,
                                   reviewRatingAverage: 3.5))
}
