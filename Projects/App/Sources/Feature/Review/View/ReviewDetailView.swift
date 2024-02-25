//
//  ReviewDetailView.swift
//  gambler
//
//  Created by 박성훈 on 2/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ReviewDetailView: View {
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    
    let reviewData: AvailableAggregateReview
    
    var reviewRatingCount: String {
        "\(String(format: "%.1f", reviewData.reviewRatingAverage))(\(reviewData.reviewCount))"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack(spacing: 8) {
                    Text("리뷰")
                        .font(.subHead1B)
                        .foregroundStyle(Color.gray700)
                    Text(reviewRatingCount)
                        .font(.body1B)
                        .foregroundStyle(Color.primaryDefault)
                    Spacer()
                }
                
                VStack(spacing: 16) {
                    ForEach(reviewViewModel.dummyReviews, id: \.self) { review in
                        ReviewDetailCellView(reviewData: review)
                        
                        if review != reviewViewModel.dummyReviews.last {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .scrollIndicators(.hidden)
        .navigationTitle("리뷰 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    WriteReviewView()
                } label: {
                    Image("review")
                        .resizable()
                        .frame(width: 23.1, height: 23.1)
                        .foregroundStyle(Color.gray400)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReviewDetailView(reviewData: Shop.dummyShop)
            .environmentObject(ReviewViewModel())
    }
}
