//
//  ShopListView.swift
//  gambler
//
//  Created by cha_nyeong on 2/28/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopListView: View {
    @EnvironmentObject private var shopListViewModel: ShopListViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    
    let title: String
    #warning("수정 필요 NavigationLink 오류")
    
    var body: some View {
        VStack(spacing: 12) {
            headerView(title: title, showGrid: shopListViewModel.showGrid)
            
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(shopListViewModel.shops) { shop in
                        NavigationLink(value: shop) {
                            ShopListCellView(shop: shop, likeShopIdArray: [])
                        }
                        if shop != shopListViewModel.shops.last {
                            Divider()
                        }
                    }
                }
                .padding(.top, 24)
            }
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private func headerView(title: String, showGrid: Bool) -> some View {
        HStack(alignment: .center, spacing: .zero) {
            GamblerAsset.arrowLeft.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    appNavigationPath.homeViewPath.removeLast()
                }
            
            Spacer()
            
            Text(title)
                .font(.subHead2B)
                .foregroundStyle(.black)
            
            Spacer()
        }
        .frame(height: 30)
    }
}

#Preview {
    NavigationStack {
        ShopListView(title: "인기 매장")
            .environmentObject(AppNavigationPath())
            .environmentObject(ShopListViewModel())
    }
}
