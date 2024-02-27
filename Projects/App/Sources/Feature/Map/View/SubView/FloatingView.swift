//
//  FloatingView.swift
//  gambler
//
//  Created by daye on 2/26/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct FloatingView: View {
    @ObservedObject var shopStore: ShopStore
    @Binding var selectedShop: Shop
    @Binding var isShowingSheet: Bool
    @Binding var userLocate: GeoPoint
    
    var body: some View {
        VStack(spacing: 0) {
            FloatingCellView(shop: selectedShop, likeShopIdArray: ["1"])
                .padding(16)
            showListButtonView
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(16)
    }
    
    private var showListButtonView: some View {
        Button(action: {
            shopStore.fetchUserAreaShopList(userPoint: userLocate)
            isShowingSheet = true
        }, label: {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray200)
                .frame(width: 295, height: 34)
                .overlay {
                    Text("목록으로 보기")
                        .font(.caption1M)
                        .foregroundStyle(Color.gray400)
                }
        })
    }
}

#Preview {
    FloatingView(shopStore: ShopStore(), 
                 selectedShop: .constant(Shop.dummyShop),
                 isShowingSheet: .constant(true),
                 userLocate: .constant(GeoPoint(latitude: 13.00, longitude: 13.00)))
}
