//
//  HomeGameCardHScrollView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeGameCardHScrollView: View {
    let title: String
    var games: [Game]
    
    var body: some View {
        VStack(spacing: 24) {
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
            .padding(.trailing, 24)
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(games) { game in
                        NavigationLink(value: game) {
                            CardItemView(game: game)
                        }
                    }
                }
            }
        }
        .padding(.leading, 24)
    }
}

#Preview {
    HomeGameCardHScrollView(title: "흥미진진 신규게임", games: HomeViewModel().newGames)
}
