//
//  GameCategoryCellView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/11/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameGenreCellView: View {
    let genre: GameGenre

    var body: some View {
        VStack(spacing: 16) {
            Image(genre.imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()
                .clipShape(Circle())
            
            Text(genre.koreanName)
                .font(.body2M)
                .foregroundStyle(Color.gray700)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 80)
        }
    }
}

#Preview {
    GameGenreCellView(genre: GameGenre.fantasy)
}
