//
//  CustomSheetView.swift
//  gambler
//
//  Created by daye on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct CustomSheetView: View {
    
    var body: some View {
        VStack {
            Indicater
                .padding(.vertical, 12)
            Text("네비게이션")
                .frame(height: 56)
            
            ScrollView {
                LazyVStack {
                   Text("매장 리스트")
                }.padding(.vertical, 12)
                .frame(minHeight: UIScreen.main.bounds.size.height - getSafeAreaTop())
            }
        }.background(Color.white)
            .roundedCorner(16, corners: [.topLeft, .topRight])
    }
    
    private var Indicater: some View {
        Rectangle()
            .foregroundStyle(Color.gray100)
            .frame(width: 48, height: 4)
            .cornerRadius(10)
    }
}

#Preview {
    CustomSheetView()
}
