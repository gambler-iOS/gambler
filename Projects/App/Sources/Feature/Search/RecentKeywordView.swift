//
//  RecentKeywordView.swift
//  gambler
//
//  Created by cha_nyeong on 2/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import SwiftData

struct RecentKeywordView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [SearchKeyword]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("최근 검색어")
                    .font(.subHead2M)
                Spacer()
                
                if !items.isEmpty {
                    Button {
                        print("전체 삭제 눌림")
                        deleteItems()
                    } label: {
                        Text("전체 삭제")
                            .font(.caption2M)
                            .underline()
                            .tint(Color.gray500)
                    }
                }
            }
            
            TagLayout(alignment: .leading, spacing: 8) {
                ForEach(items) { item in
                    ChipView(label: item.keyword, size: .medium)
                }
            }
        }
    }
    
    private func deleteItems() {
        withAnimation {
            do {
                try modelContext.delete(model: SearchKeyword.self)
            } catch {
                print("Failed to delete all SearchKeyword.")
            }
        }
    }
}

#Preview {
    RecentKeywordView()
}
