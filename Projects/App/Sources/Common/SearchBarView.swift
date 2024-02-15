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

    var body: some View {
        HStack {
            GamblerAsset.tabSearch.swiftUIImage
                .foregroundColor(.gray)

            TextField("게임, 지역, 장르 등 검색", text: $searchText)
                .foregroundColor(.primary)

            Button(action: {
                // Handle search action
            }) {
                Text("Search")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
