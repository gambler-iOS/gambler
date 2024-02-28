//
//  GameDetailInfoView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameDetailInfoView: View {
    let game: Game
    
    var body: some View {
        VStack(spacing: 32) {
            TagLayout {
                ChipView(label: "👥 3 - 10명", size: .medium)
                ChipView(label: "🕛 10분 내외", size: .medium)
                ChipView(label: "📖 마피아", size: .medium)
                ChipView(label: "🟡 난이도 하", size: .medium)
            }
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("게임 방법")
                        .font(.body1B)
                    // 색상 8A8A8A
                    Text(game.descriptionContent)
                        .font(.body2M)
                        .foregroundStyle(Color.gray500)
                }
                VStack(spacing: .zero) {
                    if let descriptionImageUrls = game.descriptionImage {
                        ForEach(descriptionImageUrls, id: \.self) { imageUrlString in
                            if let url = URL(string: imageUrlString) {
                                KFImage(url)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                                    .scaledToFit()
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    GameDetailInfoView(game: Game.dummyGame)
}
