//
//  MyReviewView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct MyReviewsView: View {
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @State private var selectedFilter = AppConstants.MyPageFilter.allCases.first ?? .shop
    
    var body: some View {
        VStack(spacing: 6) {
            SegmentTabView<AppConstants.MyPageFilter>(selectedFilter: self.$selectedFilter)
                .padding(.top, 24)
            
            switch selectedFilter {
            case .shop:
                reviewListView(reviewData: myPageViewModel.shopReviews)
            case .game:
                reviewListView(reviewData: myPageViewModel.gameReviews)
            }
        }
        .navigationTitle("나의 리뷰")
        .modifier(BackButton())
    }
    
    @ViewBuilder
    private func reviewListView(reviewData: [Review]) -> some View {
        if reviewData.isEmpty {
            VStack {
                Spacer()
                Text("작성된 리뷰가 없습니다.")
                Text("첫 리뷰를 남겨주세요!")
                Spacer()
            }
            .font(.body1M)
            .foregroundStyle(Color.black)
        } else {
            ScrollView {
                VStack(spacing: 24) {
                    Rectangle()
                        .frame(height: 0)
                        .padding(.bottom, 0)         
                    
                    ForEach(reviewData, id: \.self) { review in
                        ReviewDetailCellView(reviewData: review)
                            .padding(.bottom, -8)
                        
                        if review != reviewData.last {
                            Divider()
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    MyReviewsView()
        .environmentObject(MyPageViewModel())
}
