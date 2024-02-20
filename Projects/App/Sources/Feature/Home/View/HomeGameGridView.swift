//
//  HomeGamesGridView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeGameGridView: View {
    let title: String
    let games: [Game]
    let columns: [GridItem] = Array(repeating:
            .init(.flexible(minimum: 124, maximum: 180),
                  spacing: 17, alignment: .leading), count: 2)

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // TODO: SectionHeaderView 에서 패딩 제외해도 되는지 물어보고 사용하기
            HStack {
                Text(title)
                    .font(.subHead1B)
                    .foregroundStyle(Color.gray700)
                Spacer()
                GamblerAsset.arrowRight.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.gray400)
            }
            
            LazyVGrid(columns: columns, spacing: 24, content: {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameGridItemView(game: game, likeGameIdArray: [])
                    }
                }
            })
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeGameGridView(title: "인기 게임", games: HomeViewModel().popularGames)
}
