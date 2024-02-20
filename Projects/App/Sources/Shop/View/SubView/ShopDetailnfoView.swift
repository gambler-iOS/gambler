//
//  ShopDetailInfo.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopDetailInfoView: View {
    var shop: Shop
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            makeInfoTable(title: "운영 시간", content: shop.openingHour)
            makeInfoTable(title: "편의", content: shop.amenity)
            makeInfoTable(title: "이용 가격", content: "이용가격 모델에 추가할것")
            makeInfoTable(title: "메뉴", content: shop.menu)
        }
    }
    
    private func makeInfoTable (title: String, content: Any?) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
               Text(title)
                   .font(.body1B)

               Group {
                   if let textContent = content as? String {
                       HStack {
                           Text("•")
                           Text("\(textContent)")
                       }
                   } else if let dictionaryContent = content as? [String: Int] {
                       ForEach(dictionaryContent.sorted(by: >), id: \.key) { key, value in
                           HStack {
                               Text("•")
                               Text("\(key)")
                               Spacer()
                               Text("\(value)원")
                           }
                       }
                   } else if let arrayContent = content as? [String] {
                       HStack {
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
               .font(.body2M)
               .padding(.top, 8)
           }
           .foregroundStyle(Color.gray700)
           .padding(.vertical, 12)
       }

   }

   #Preview {
       ShopDetailInfoView(shop: Shop.dummyShop)
   }
