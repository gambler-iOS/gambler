//
//  BlackSectionHeaderView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct DetailSectionHeaderView: View {
    let title: String
    var reviewInfo: String?
    var navigationPath: () -> Void
    
    var body: some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(.subHead1B)
                .foregroundStyle(.black)
            
            if let reviewInfo {
                Text(reviewInfo)
                    .font(.body1B)
                    .foregroundStyle(Color.primaryDefault)
                    .padding(.leading, 8)
            }
            
            Spacer()
            
            GamblerAsset.arrowRight.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    navigationPath()
                }
        }
    }
}

#Preview {
    DetailSectionHeaderView(title: "비슷한 장르 게임", navigationPath: {})
}
