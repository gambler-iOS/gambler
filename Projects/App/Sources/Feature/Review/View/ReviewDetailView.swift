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
    let targetName: String  // 앱/게임 이름
    
    var reviewRatingCount: String {
        "\(String(format: "%.1f", reviewableItem.reviewRatingAverage))(\(reviewableItem.reviewCount))"
    }
    
    var body: some View {
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
            
            if reviewViewModel.reviews.isEmpty {
                EmptyView()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(reviewViewModel.reviews, id: \.self) { review in
                            ReviewDetailCellView(name: targetName, reviewData: review)
                            
                            if review != reviewViewModel.reviews.last {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .onAppear {
            Task {
                await reviewViewModel.fetchReviewData(reviewableItem: reviewableItem)
            }
        }
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
    
    @ViewBuilder
    private func EmptyView() -> some View {
        VStack {
            Spacer()
            Text("작성된 리뷰가 없습니다.")
            Text("첫 리뷰를 남겨주세요!")
            Spacer()
        }
        .font(.body1M)
        .foregroundStyle(Color.black)
    }
}

#Preview {
    NavigationStack {
        ReviewDetailView(reviewableItem: Shop.dummyShop, targetName: "하나비")
            .environmentObject(ReviewViewModel())
    }
}
