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
                ForEach(game.chipViewLabel, id: \.self) { label in
                    ChipView(label: label, size: .medium)
                }
            }
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("게임 방법")
                        .font(.body1B)
                    // 색상 8A8A8A
                    Text(splitTextByPeriod(text: game.descriptionContent))
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
    
    private func splitTextByPeriod(text: String) -> String {
            var newText = text
            newText = newText.replacingOccurrences(of: ". ", with: ".\n")
            return newText
    }
}


#Preview {
    GameDetailInfoView(game: Game.dummyGame)
}
