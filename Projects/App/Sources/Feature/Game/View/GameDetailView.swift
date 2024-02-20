//
//  GameDetailView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct GameDetailView: View {
    @Binding var path: NavigationPath
    let game: Game
    
    var body: some View {
        ScrollView {
            Text(game.gameName)
            
            Spacer()
            #warning("GameDetail 더미, NavigationPath 동작 보여주기 위해 추가함")
            HomeGameGridView(title: "연관게임", games: HomeViewModel().popularGames)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Back to List") {
                    path = NavigationPath()
                }
            }
        }
    }
}

#Preview {
    GameDetailView(path: .constant(NavigationPath()), game: Game.dummyGame)
}
