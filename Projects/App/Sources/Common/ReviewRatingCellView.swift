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
    
    var body: some View {
        HStack(spacing: 4) {
            Group {
                GamblerAsset.star.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 18, height: 18)
                
                Text(String(format: "%.1f", rating))
                    .foregroundStyle(textColor)
            }
            .foregroundStyle(Color.primaryDefault)
        }
        .font(.caption1M)
    }
}

#Preview {
    ReviewRatingCellView(rating: 3.9)
}
