//
//  ReviewRatingCellView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/13/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ReviewRatingCellView: View {
    let rating: Double
    var textColor: Color = .primaryDefault
    private var formattedReviewRating: String {
        if rating == 0 {
            return "0"
        } else {
            return String(format: "%.1f", rating)
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Group {
                GamblerAsset.star.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 18, height: 18)
                
                Text("\(formattedReviewRating)")
                    .foregroundStyle(textColor)
            }
            .foregroundStyle(Color.primaryDefault)
        }
        .font(.caption1M)
    }
}

#Preview {
    ReviewRatingCellView(rating: 4.2)
}
