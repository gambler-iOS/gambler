//
//  HomeShopListView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeShopListView: View {
    let title: String
    var shops: [Shop]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // TODO: SectionHeaderView 에서 패딩 제외해도 되는지 물어보고 사용하기
                HStack {
                    Text(title)
                        .font(.subHead1B)
                        .foregroundStyle(Color.gray700)
                    Spacer()
                    GamblerAsset.arrowRight.swiftUIImage
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.gray400)
                }
                
                ForEach(shops) { shop in
                    NavigationLink(value: shop) {
                        ShopListCellView(shop: shop, likeShopIdArray: [])
                    }
                    if shop != shops.last {
                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeShopListView(title: "인기 매장", shops: [Shop.dummyShop])
}
