//
//  ReviewListCellView.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ReviewListCellView: View {
    let review: Review
   
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            
            if let firstImageURL = review.reviewImage?.first, let image = URL(string: firstImageURL) {
                KFImage(image)
                    .resizable()
                    .frame(width: 56, height: 56)
                    .cornerRadius(4)
                    .clipped()
                    .padding(.vertical, 17)
            }
            
            VStack(alignment: .leading, spacing: 0){
                ReviewRatingCellView(review: review.reviewRating)
                    .padding(.bottom, 5)
                Text(review.reviewContent)
                    .font(.caption1M)
                    .foregroundStyle(Color.gray700)
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 0))
            
        }
        .frame(width: 252, height: 90)
        .padding(.horizontal, 8)
        .background(Color.gray50)
        .cornerRadius(8)
        
    }

}

#Preview {
    ReviewListCellView(review: Review.dummyReview)
}
