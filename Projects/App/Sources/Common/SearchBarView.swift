//
//  SearchBarView.swift
//  gambler
//
//  Created by cha_nyeong on 2/14/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import SwiftData

struct SearchBarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [SearchKeyword]
    @Binding var searchText: String
    @Binding private var isEditing: Bool
    @Binding private var isSearch: Bool
    private let placeholder: String
    private var onSubmit: () -> Void
    
    init(searchText: Binding<String>,
         isEditing: Binding<Bool>,
         isSearch: Binding<Bool>,
         placeholder: String = "게임, 지역, 장르 등 검색",
         onSubmit: @escaping () -> Void) {
        _searchText = searchText
        _isEditing = isEditing
        _isSearch = isSearch
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                GamblerAsset.tabSearch.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray300)
                
                TextField(placeholder, text: $searchText,
                          onCommit: {
                    onSubmit()
                    addItem()
                    isEditing = true
                    isSearch = true
                })
                .foregroundColor(.gray600)
                .keyboardType(.webSearch)
                .overlay(
                    HStack {
                        Spacer()
                        if isEditing && !searchText.isEmpty {
                            Button {
                                searchText = ""
                                isEditing = false
                                isSearch = false
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray400)
                                    .frame(width: 24, height: 24)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                )
            }
            .onTapGesture {
                isEditing = true
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.gray50)
            .frame(height: 44)
            .cornerRadius(8)
        }
    }
    
    private func addItem() {
        let newItem = SearchKeyword(timestamp: Date(), keyword: "")
        newItem.keyword = searchText
        if !items.contains(where: {
            $0.keyword == searchText
        }) {
            modelContext.insert(newItem)
        }
        do {
            if items.count > 9 {
                modelContext.delete(items[0])
            }
            try modelContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

//#Preview {
//    SearchBarView(searchText: .constant(""))
//}
