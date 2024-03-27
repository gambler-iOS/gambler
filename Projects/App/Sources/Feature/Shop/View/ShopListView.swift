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
    
    private var titleType: ListTypeEnum {
        if title.contains("인기") {
            return .popular
        } else if title.contains("신규") {
            return .newly
        } else {
            return .normal
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            headerView(title: title)
            
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(shopListViewModel.shops) { shop in
                        NavigationLink(value: shop) {
                            ShopListCellView(shop: shop)
                        }
                        if shop != shopListViewModel.shops.last {
                            Divider()
                        }
                    }
                }
                .padding(.top, 24)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
        .task {
            await shopListViewModel.fetchData(type: titleType)
        }
    }
    
    @ViewBuilder
    private func headerView(title: String) -> some View {
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
            
            Text("")
                .frame(width: 24, height: 24)
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
