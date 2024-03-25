//
//  GameListViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import SwiftUI

final class GameListViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var showGrid: Bool = false
    
    private let firebaseManager = FirebaseManager.shared
    private let collectionName: String = AppConstants.CollectionName.games
    
    private var convertGenreToString: [String] {
        games.first?.gameIntroduction.genre.map { $0.rawValue } ?? []
    }
    
    private func convertStringToGenre(koreanName: String) -> [String] {
        if let theme = GameGenre.allCases.first(where: { $0.koreanName == koreanName }) {
            return [theme.rawValue]
        }
        return []
    }
    
    init() {
//        generateDummyData()
    }

    private func generateDummyData() {
        games = Game.dummyGameList
    }
    
    @MainActor
    func fetchData(title: String) async {
        var tempGames: [Game] = []
        games.removeAll()
        do {
            if title.contains("인기") || title.contains("Best") {
                tempGames = try await firebaseManager.fetchOrderData(collectionName: collectionName,
                                                                 orderBy: "reviewCount", limit: 10)
            } else if title.contains("신규") {
                tempGames = try await firebaseManager.fetchOrderData(collectionName: collectionName,
                                                                 orderBy: "createdDate", limit: 10)
            } else if title.contains("비슷한 장르") {
                tempGames = try await firebaseManager
                    .fetchWhereArrayContainsData(collectionName: collectionName, field: "gameIntroduction.genre",
                                                 arrayContainsAny: convertGenreToString, limit: 5)
            } else if title.contains("비슷한 인원수") {
                tempGames = try await firebaseManager
                    .fetchWhereIsEqualToData(collectionName: collectionName,
                                             field: "gameIntroduction.maxPlayerCount",
                                             isEqualTo: games.first?.gameIntroduction.maxPlayerCount ?? 0,
                                             limit: 5)
            } else {
                /// 종류별 Best 에서 장르 하나 선택 시 진입
                tempGames = try await firebaseManager
                    .fetchWhereArrayContainsData(collectionName: collectionName, field: "gameIntroduction.genre",
                                                 arrayContainsAny: convertStringToGenre(koreanName: title),
                                                 limit: 5)
            }
        } catch {
            print("Error fetching \(collectionName) : \(error.localizedDescription)")
        }
        self.games = tempGames
    }
}
