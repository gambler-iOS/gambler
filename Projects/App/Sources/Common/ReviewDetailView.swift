//
//  ReviewDetailView.swift
//  gambler
//
//  Created by 박성훈 on 2/12/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ReviewDetailView: View {
    let reviewData: Review
    let target: AvailableAggregateReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(reviewData.id)
                .font(.body1M)
                .foregroundStyle(Color.gray700)
            
            HStack(spacing: 8) {
                ReviewRatingCellView(review: target)
                // target이 내가 준 평점으로 줘야하는데 가게의 평점을 줘야해서 ReviewRatingCellView로 하기에는 게임/샵 자체의 평점이 올라가기 때문에 문제가 있어보임
                
                Text(reviewData.createdDate.summary)
                    .foregroundStyle(Color.gray400)
            }
            .font(.caption1M)
            
            Text(reviewData.reviewContent)
                .font(.body2M)
                .foregroundStyle(Color.gray400)
                .padding(.bottom, 8)
            
            if let reviewImages = reviewData.reviewImage {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(reviewImages, id: \.self) { image in
                            if let url = URL(string: image) {
                                KFImage(url)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(.rect(cornerRadius: 8))
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 64, height: 64)
                                    .foregroundStyle(Color.gray200)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ReviewDetailView(reviewData: Review.dummyReview, target: Game.dummyGame)
}
