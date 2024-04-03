//
//  FloatingView.swift
//  gambler
//
//  Created by daye on 2/26/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct FloatingView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Binding var selectedShop: Shop?
    @Binding var isShowingSheet: Bool
    @Binding var userLocate: GeoPoint
    
    var body: some View {
        VStack(spacing: 0) {
            if selectedShop == nil {
                Text("내 주변에 매장이 없어요.")
                    .font(.body2B)
                    .foregroundStyle(Color.gray400)
                    .frame(height: 100)
                    .padding(16)
            } else {
                NavigationLink(destination: ShopDetailInfoView(shop: selectedShop ?? Shop.dummyShop)) {
                    FloatingCellView(shop: selectedShop ?? Shop.dummyShop, likeShopIdArray: ["1"])
                        .padding(16)
                }
            }
            
            showListButtonView
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(16)
    }
    
    private var showListButtonView: some View {
        Button(action: {
            Task {
                let userCountry = await mapViewModel.getCountry(mapPoint: userLocate)
                await mapViewModel.filterShopsByCountry(country: userCountry)
                withAnimation {
                    isShowingSheet = true
                }
            }
        }, label: {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray200)
                .frame(width: 295, height: 34)
                .overlay {
                    Text("내 주변 목록")
                        .font(.caption1M)
                        .foregroundStyle(Color.gray400)
                }
        })
    }
}

#Preview {
    FloatingView(mapViewModel: MapViewModel(),
                 selectedShop: .constant(Shop.dummyShop),
                 isShowingSheet: .constant(true),
                 userLocate: .constant(GeoPoint(latitude: 13.00, longitude: 13.00)))
}
