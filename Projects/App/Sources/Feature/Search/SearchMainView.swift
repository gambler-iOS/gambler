//
//  SearchMainView.swift
//  gambler
//
//  Created by cha_nyeong on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import SwiftData

struct SearchMainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [SearchKeyword]
    @State private var searchText: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                SearchBarView(searchText: $searchText)
                
                RecentKeywordView()
                
                Button {
                    addItem()
                } label: {
                    Text("추가")
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = SearchKeyword(timestamp: Date(), keyword: "")
            newItem.keyword = searchText
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    SearchMainView()
}
