//
//  ReviewDetailView.swift
//  gambler
//
//  Created by 박성훈 on 2/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ReviewDetailView: View {
    @EnvironmentObject private var reviewViewModel: ReviewViewModel
    @State private var isShowingToast: Bool = false
    let reviewableItem: AvailableAggregateReview
    
    var reviewRatingCount: String {
        "\(String(format: "%.1f", reviewableItem.reviewRatingAverage))(\(reviewableItem.reviewCount))"
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
        .modifier(BackButton())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    WriteReviewView(isShowingToast: $isShowingToast, reviewableItem: reviewableItem)
                } label: {
                    Image("review")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .overlay {
            if isShowingToast {
                toastMessageView
            }
        }
    }
    
    private var toastMessageView: some View {
        CustomToastView(content: "리뷰 작성이 완료되었습니다!")
            .offset(y: UIScreen.main.bounds.height * 0.3)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isShowingToast = false
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        ReviewDetailView(reviewableItem: Shop.dummyShop)
            .environmentObject(ReviewViewModel())
    }
}
