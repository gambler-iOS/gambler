//
//  RatingView.swift
//  gambler
//
//  Created by 박성훈 on 2/26/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Double
    @Binding var count: Int
    let imageSize: Double = 48
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(1...count, id: \.self) { index in
                
                let doubleIndex = Double(index)
                
                Image(starType(index))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .onTapGesture(coordinateSpace: .local) { location in
                        handleTap(at: doubleIndex, location: location)
                    }
                #warning("onTapGesture(coordinateSpace: .local) - Deprecated")
            }
        }
    }
    
    private func handleTap(at index: Double, location: CGPoint) {
        let isTappedOnLeftSide = location.x <= imageSize / 2
        rating = isTappedOnLeftSide ? index - 0.5 : index
    }
    
    private func starType(_ index: Int) -> String {
        let roundedRating = Int(ceil(rating))
        
        if index <= roundedRating {
            if index <= Int(rating) {
                return "star"
            } else {
                return "halfStar"
            }
        }
        
        return "emptyStar"
    }
}

#Preview {
    RatingView(rating: .constant(3.5), count: .constant(5))
}
