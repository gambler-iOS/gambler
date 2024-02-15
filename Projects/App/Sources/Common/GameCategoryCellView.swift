//
//  GameCategoryCellView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/11/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameCategoryCellView: View {
    let imageUrl: String
    let name: String

    var body: some View {
        VStack(spacing: 16) {
            if let url = URL(string: imageUrl) {
                KFImage(url)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .scaledToFit()
                    .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 80, height: 80)
            }
            
            Text(name)
                .font(.body2M)
                .foregroundStyle(Color.gray700)
        }
    }
}

#Preview {
    GameCategoryCellView(imageUrl: "", name: "전략")
}
