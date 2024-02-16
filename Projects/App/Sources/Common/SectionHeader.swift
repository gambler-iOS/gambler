//
//  SectionHeader.swift
//  gambler
//
//  Created by daye on 2/7/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct SectionHeader: View {
    var title: String
    var rating: String?
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.subHead1B)
                .foregroundStyle(Color.gray700)
            
            if let content = rating {
                Text(content)
                    .font(.body1B)
                    .foregroundStyle(Color.primaryDefault)
                    .padding(.leading, 8)
           }
            
            Spacer()
            GamblerAsset.arrowRight.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
        }.padding(24)
    }
}

#Preview {
    SectionHeader(title: "인기매장")
}
