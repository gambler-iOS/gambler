//
//  HomeGameCategoryHScrollView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeGameCategoryHScrollView: View {
    let title: String
    var categoryNames: [String]
    
    var body: some View {
        VStack(spacing: 24) {
            SectionHeaderView(title: title)
                .padding(.trailing, 24)
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(categoryNames, id: \.self) { categotyName in
                        GameCategoryCellView(imageUrl: "", name: categotyName)
                    }
                }
            }
        }
        .padding(.leading, 24)
        .padding(.vertical, 32)
        .background(Color.gray50)
    }
}

#Preview {
    HomeGameCategoryHScrollView(title: "종류별 Best", categoryNames: ["마피아", "블러핑"])
}
