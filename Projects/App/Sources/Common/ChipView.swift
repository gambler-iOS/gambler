//
//  ChipView.swift
//  gambler
//
//  Created by cha_nyeong on 2/13/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ChipView: View {
    var label: String
    var size: ChipSize
    
    var body: some View {
        switch size {
        case .small:
            Text(label)
                .foregroundStyle(Color.gray500)
                .font(.caption2M)
                .padding(.horizontal, AppConstants.ChipSize.small.width)
                .padding(.vertical, AppConstants.ChipSize.small.height)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray200)
                        .background(Color.clear)
                )
        case .medium:
            Text(label)
                .foregroundStyle(Color.gray500)
                .font(.caption1M)
                .padding(.horizontal, AppConstants.ChipSize.medium.width)
                .padding(.vertical, AppConstants.ChipSize.medium.height)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray200)
                        .background(Color.clear)
                )
        }
    }
}

enum ChipSize {
    case small
    case medium
}

struct ChipView_ExView: View {
    var body: some View {
        VStack {
            ChipView(label: "마피아 게임", size: .medium)
            ChipView(label: "마피아 게임", size: .small)
            ChipView(label: "Programming", size: .medium)
        }
        .padding()
    }
}

#Preview {
    ChipView_ExView()
}
