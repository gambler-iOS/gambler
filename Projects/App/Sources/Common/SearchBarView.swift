//
//  SearchBarView.swift
//  gambler
//
//  Created by cha_nyeong on 2/14/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                GamblerAsset.tabSearch.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray300)
                
                TextField("게임, 지역, 장르 등 검색", text: $searchText, onEditingChanged: { _ in
                    withAnimation(.interpolatingSpring, {
                        self.isEditing.toggle()
                    })
                })
                .foregroundColor(.gray400)
                .keyboardType(.webSearch)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray400)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .ignoresSafeArea()
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.gray50)
            .frame(height: 44)
            .cornerRadius(8)
        }
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
