//
//  FloatingView.swift
//  gambler
//
//  Created by daye on 2/26/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct FloatingView: View {
    let shop: Shop
    @Binding var isShowingSheet: Bool
    
    var body: some View {
        VStack {
            FloatingCellView(shop: Shop.dummyShop)
                .padding(16)
            showListButtonView
                .padding(16)
        }.frame(width: 327, height: 187)
            .cornerRadius(16)
    }
    
    private var showListButtonView: some View {
        Button {
            isShowingSheet.toggle()
            
        } label: {
            Text("목록으로 보기")
                .font(.caption1M)
                .foregroundStyle(Color.gray400)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray200)
                    .background(Color.clear)
                    .frame(width: 295, height: 34)
                    
            )
        }

    }
}

#Preview {
    FloatingView(shop: Shop.dummyShop, isShowingSheet: .constant(true))
}
