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
        VStack {
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
                    Text("마피아 류의 보드게임으로 늑대인간을 죽이는 것이 목표이다. 타뷸라의 늑대와도 비슷한데 한밤의 늑대인간은 하룻밤만 지나면 토론을 하여 단 한번만 투표를 한다. 때문에 한 판의 플레이 타임은 10분 정도로 매우 짧다.")
                        .font(.body2M)
                        .foregroundStyle(Color.gray500)
                }
                VStack(spacing: .zero) {
                    ForEach(game.descriptionImage, id: \.self) { imageUrlString in
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
        .padding(.horizontal, 24)
    }
}

#Preview {
    GameDetailInfoView(game: Game.dummyGame)
}
