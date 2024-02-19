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
            // TODO: SectionHeaderView 에서 패딩 제외해도 되는지 물어보고 사용하기
            HStack {
                Text(title)
                    .font(.subHead1B)
                    .foregroundStyle(Color.gray700)
                Spacer()
                GamblerAsset.arrowRight.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.gray400)
            }
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
