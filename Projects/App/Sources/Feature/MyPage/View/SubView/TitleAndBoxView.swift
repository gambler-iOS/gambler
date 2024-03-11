//
//  TitleAndBoxView.swift
//  gambler
//
//  Created by daye on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct TitleAndBoxView: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .padding(.vertical, 8)
                .foregroundColor(Color.gray700)
                .font(.caption1M)
            Rectangle()
                .frame(height: 56)
                .cornerRadius(8)
                .foregroundStyle(Color.gray50)
        }
    }
}

#Preview {
    TitleAndBoxView(title: "닉네임")
}
