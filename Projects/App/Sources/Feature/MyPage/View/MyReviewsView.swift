//
//  MyReviewView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct MyReviewsView: View {
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    @State private var selectedFilter = AppConstants.MyPageFilter.allCases.first ?? .shop

    var body: some View {
        VStack(spacing: 0) {
            SegmentTabView<AppConstants.MyPageFilter>(selectedFilter: self.$selectedFilter)
            
            if selectedFilter == .shop {
                reviewListView(reviewData: myPageViewModel.shopReviews)
            } else {
                reviewListView(reviewData: myPageViewModel.gameReviews)
            }
        }
        .navigationTitle("나의 리뷰")
    }
    
    @ViewBuilder
    private func reviewListView(reviewData: [Review]) -> some View {
        List {
            ForEach(reviewData, id: \.self) { review in
                ReviewDetailView(reviewData: review)
                    .padding(.top, 24)
            }
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
    }
}

#Preview {
    MyReviewsView()
        .environmentObject(MyPageViewModel())
}
