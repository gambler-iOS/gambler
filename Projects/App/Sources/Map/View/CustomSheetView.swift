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
            indicaterView
                .padding(.vertical, 12)
            Text("네비게이션")
                .frame(height: 56)
            
            ScrollView {
                Text("매장 리스트 뷰")
            }.frame(width: UIScreen.main.bounds.width)
                . padding(.vertical, 12)
        }.background(Color.white)
            .roundedCorner(16, corners: [.topLeft, .topRight])
    }
    
    private var indicaterView: some View {
        Rectangle()
            .foregroundStyle(Color.gray100)
            .frame(width: 48, height: 4)
            .cornerRadius(10)
    }
}

#Preview {
    CustomSheetView()
}
