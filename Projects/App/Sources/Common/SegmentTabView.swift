//
//  SegmentTabView.swift
//  gambler
//
//  Created by cha_nyeong on 2/14/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct SegmentTabView<T: FilterType & Identifiable & Equatable>: View where T.AllCases: RandomAccessCollection {
    @State private var selectedFilter = T.allCases.first
    @Namespace var animation
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(T.allCases.count)
        return (UIScreen.main.bounds.width - 48) / count
    }
    
    var body: some View {
        // TabView 항목
        VStack {
            HStack(spacing: 0) {
                ForEach(T.allCases) { filter in
                    VStack {
                        Text(filter.title)
                            .font(selectedFilter == filter ? .body2B : .body2M)
                            .foregroundStyle(Color.gray700)
                        
                        if selectedFilter == filter {
                            Rectangle()
                                .foregroundColor(.gray700)
                                .frame(width: filterBarWidth, height: 2)
                                .matchedGeometryEffect(id: "myPage", in: animation)
                        } else {
                            Rectangle()
                                .foregroundColor(.gray100)
                                .frame(width: filterBarWidth, height: 2)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedFilter = filter
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    SegmentTabView<AppConstants.MyPageFilter>()
//    SegmentTabView<AppConstants.SearchFilter>()
}
