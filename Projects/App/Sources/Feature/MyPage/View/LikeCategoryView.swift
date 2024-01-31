//
//  LikeCategoryView.swift
//  gambler
//
//  Created by 박성훈 on 1/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct LikeCategoryView: View {
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    @State private var selectedPicker: MyPageViewModel.LikeCategory = .shop
    @Namespace private var animation
    
    var body: some View {
        VStack {
            animate()
            LikeListView(category: selectedPicker)
        }
        .navigationTitle("좋아요")
    }
    
    @ViewBuilder  // 클로저에서 뷰를 구성한다.
    private func animate() -> some View {
        HStack {
            ForEach(MyPageViewModel.LikeCategory.allCases, id: \.self) { item in
                VStack {
                    HStack {
                        Text(item.rawValue)
                            .font(.title3)
                            .foregroundStyle(selectedPicker == item ? .black : .gray)
                        Text("3")
                            .foregroundStyle(.orange)
                    }
                    .frame(maxWidth: .infinity/2, minHeight: 50)
                    
                    if selectedPicker == item {
                        Capsule()
                            .foregroundStyle(.orange)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "category", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
    }
}

#Preview {
    LikeCategoryView()
}
