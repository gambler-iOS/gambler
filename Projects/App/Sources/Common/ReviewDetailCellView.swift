//
//  ReviewDetailView.swift
//  gambler
//
//  Created by 박성훈 on 2/12/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ReviewDetailCellView: View {
    
    let name: String
    let reviewData: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.body1M)
                .foregroundStyle(Color.gray700)
            
            HStack(spacing: 8) {
                ReviewRatingCellView(rating: reviewData.reviewRating)
                
                Text(GamblerDateFormatter.shared.calendarDateString(from: reviewData.createdDate))
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
    ReviewDetailCellView(name: "리뷰~", reviewData: Review.dummyGameReview)
}
