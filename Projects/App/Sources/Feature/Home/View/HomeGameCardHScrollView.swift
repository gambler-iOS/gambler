//
//  HomeGameCardHScrollView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeGameCardHScrollView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    let title: String
    var games: [Game]
    
    var body: some View {
        VStack(spacing: 24) {
            SectionHeaderView(title: title)
                .onTapGesture {
                    appNavigationPath.homeViewPath.append(title)
                }
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(games) { game in
                        NavigationLink(value: game) {
                            CardItemView(game: game)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeGameCardHScrollView(title: "흥미진진 신규게임", games: HomeViewModel().newGames)
        .environmentObject(AppNavigationPath())
}
