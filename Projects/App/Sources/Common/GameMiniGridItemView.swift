//
//  GameMiniGridItemView.swift
//  gambler
//
//  Created by 박성훈 on 2/12/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameMiniGridItemView: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if let url = URL(string: game.gameImage) {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(.rect(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color.gray200)
            }
            
            Text(game.gameName)
                .font(.body2M)
                .foregroundStyle(Color.gray700)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 100)
        }
    }
}

#Preview {
    GameMiniGridItemView(game: Game.dummyGame)
}
