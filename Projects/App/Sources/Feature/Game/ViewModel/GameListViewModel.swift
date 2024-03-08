//
//  GameListViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class GameListViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var showGrid: Bool = false
    
    init() {
        generateDummyData()
    }

    func generateDummyData() {
        games = Game.dummyGameList
    }
}
