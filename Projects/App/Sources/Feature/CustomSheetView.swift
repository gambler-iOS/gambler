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
        VStack(spacing: 0) {
            ScrollView{
                Text("내가만든 간지 시트 ^0^~~~~~~~~")
                    .font(.headline)
                    .padding()
                    .background(Color.mint)
                    .foregroundStyle(Color.white)
                    .cornerRadius(10)
            }.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                .padding(.top, 84)
        }.background(Color.white)
        .roundedCorner(16, corners: [.topLeft, .topRight])
        .overlay {
            indicaterView
                .offset(y: -UIScreen.main.bounds.size.height/2  - 30)
        }
    }
    
    private var indicaterView: some View {
        Rectangle()
            .fill(Color(red: 0.85, green: 0.85, blue: 0.85))
            .frame(width: 48, height: 4)
            .cornerRadius(10)
         
    }
  
    
}
