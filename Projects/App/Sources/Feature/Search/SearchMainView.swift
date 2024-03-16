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
    
    // 그냥 shop, game의 뷰모델을 가져와서 fetch하면 안되나..?
    let seachViewModel: SearchViewModel = SearchViewModel()
   
    var filteredShops: [Shop] {
        guard !searchText.isEmpty else { return seachViewModel.shopResult }
        return seachViewModel.shopResult.filter { $0.shopName.localizedCaseInsensitiveContains(searchText) }
    }
    var filteredGames: [Game] {
        guard !searchText.isEmpty else { return seachViewModel.gameResult }
        return seachViewModel.gameResult.filter { $0.gameName.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                SearchBarView(searchText: $searchText)
                    .padding(.horizontal, 24)
                
                if searchText.isEmpty {
                    RecentKeywordView()
                        .padding(.horizontal, 24)
                    Button {
                        addItem()
                    } label: {
                        Text("추가")
                    }
                } else {
                    SearchResultView(filteredShops: filteredShops, filteredGames: filteredGames)
                }
            
                Spacer()
            }
            .padding(.top, 24)
        }
        .task {
            await seachViewModel.fetchData()
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
