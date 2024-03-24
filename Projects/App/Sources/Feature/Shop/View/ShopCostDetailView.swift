//
//  ShopCostDetailView.swift
//  gambler
//
//  Created by cha_nyeong on 3/5/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopCostDetailView: View {
    let shop: Shop
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            makeInfoTable(title: "운영 시간", content: shop.openingHour)
        }
    }
    
    private func makeInfoTable(title: String, content: Any?) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.body1B)
            Group {
                if let textContent = content as? String {
                    HStack {
                        Text("  •")
                        Text("\(textContent)")
                    }
                } else if let dictionaryContent = content as? [String: Int] {
                    ForEach(dictionaryContent.sorted(by: >), id: \.key) { key, value in
                        HStack {
                            Text("  •")
                            Text("\(key)")
                            Spacer()
                            Text("\(value)원")
                        }
                    }
                } else if let arrayContent = content as? [String] {
                    ForEach(Array(arrayContent.enumerated()), id: \.element) { index, item in
                        VStack {
                            HStack {
                                Text("  •")
                                Text(item)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .font(.body2M)
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
        }
        .foregroundStyle(Color.gray700)
    }
    
}

#Preview {
    ShopCostDetailView(shop: Shop.dummyShop)
}
