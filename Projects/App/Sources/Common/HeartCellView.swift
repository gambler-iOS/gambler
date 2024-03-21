//
//  HeartCellView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/13/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HeartCellView: View {
    let isLike: Bool

    var body: some View {
        VStack {
            if isLike {
                GamblerAsset.heartRed.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.primaryDefault)
            } else {
                GamblerAsset.heartGray.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.gray300)
            }
        }
    }
}

#Preview {
    HeartCellView(isLike: false)
}
