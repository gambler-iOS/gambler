//
//  ShopDetailInfo.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopDetailInfo: View {
    var shop: Shop?
    var body: some View {
        
        VStack(alignment: .leading){
            makeInfoTable(title: "운영 시간", content: shop?.openingHour)
            makeInfoTable(title: "편의", content: shop?.amenity)
            makeInfoTable(title: "이용 가격", content: "이거 넣으려면 모델에 넣어야하는디!")
            makeInfoTable(title: "메뉴", content: shop?.menu)
        }.padding(.vertical, 10)
            .padding(.horizontal, 10)
        
    }
    
    private func makeInfoTable (title: String, content: Any?) -> some View {
        return VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .bold()
            
            Group{
                if let textContent = content as? String {
                    HStack{
                        Text("•")
                        Text("\(textContent)")
                    }
                } else if let dictionaryContent = content as? [String: Int] {
                    ForEach(dictionaryContent.sorted(by: >), id: \.key) { key, value in
                        HStack{
                            Text("•")
                            Text("\(key)")
                            Spacer()
                            Text("\(value)원")
                        }
                    }
                } else if let arrayContent = content as? [String] {
                    HStack{
                        Text("• ")
                        ForEach(Array(arrayContent.enumerated()), id: \.element) { index, item in
                            if index == arrayContent.count - 1 {
                                Text(item)
                            } else {
                                Text("\(item),")
                            }
                        }
                    }
                }
            }
            .padding(.top, 1)
            
        }.padding(20)
    }

}

#Preview {
    ShopDetailInfo(
                        shop: Shop(id: UUID().uuidString, shopName: "shop", shopAddress: "address",
                                   shopImage: "image", location: GeoPoint(latitude: 120.1, longitude: 140),
                                   shopPhoneNumber: "010-5555", menu: ["커피": 1000, "아이스티": 2000],
                                   openingHour: "10시", amenity: ["주차","담요","와이파이"], shopDetailImage: ["detailImage"],
                                   createdDate: Date(), reviewCount: 3,
                                   reviewRatingAverage: 3.5))
}
