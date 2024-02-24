//
//  GameListView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct GameListView: View {
    @ObservedObject private var gameListViewModel = GameListViewModel()
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @Environment(\.dismiss) private var dismiss
    let title: String
    let columns: [GridItem] = Array(repeating:
            .init(.flexible(minimum: 124, maximum: 200),
                  spacing: 17, alignment: .leading), count: 2)
    
    var body: some View {
        VStack(spacing: 12) {
            headerView(title: "인기 게임", showGrid: gameListViewModel.showGrid)

            ScrollView {
                if gameListViewModel.showGrid == true {
                    LazyVGrid(columns: columns, spacing: 24, content: {
                        ForEach(gameListViewModel.games) { game in
                            NavigationLink(value: game) {
                                GameGridItemView(game: game, likeGameIdArray: [])
                            }
                        }
                    })
                } else {
                    VStack(spacing: 24) {
                        ForEach(gameListViewModel.games) { game in
                            NavigationLink(value: game) {
                                GameListItemView(game: game, likeGameIdArray: [])
                            }
                            if game != gameListViewModel.games.last {
                                Divider()
                            }
                        }
                    }
                    
                }
            }
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden()
    }
        
    @ViewBuilder
    func headerView(title: String, showGrid: Bool) -> some View {
        HStack(spacing: .zero) {
            GamblerAsset.arrowLeft.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    dismiss()
//                    appNavigationPath.viewPath.removeLast()
                }
            
            Spacer()
            
            Text(title)
                .font(.subHead2B)
                .foregroundStyle(.black)
            
            Spacer()
            
            Group {
                if showGrid == true {
                    GamblerAsset.listView.swiftUIImage
                        .resizable()
                } else {
                    GamblerAsset.gridView.swiftUIImage
                        .resizable()
                }
            }
            .frame(width: 24, height: 24)
            .onTapGesture {
                gameListViewModel.showGrid.toggle()
            }
        }
        .frame(height: 40)
    }
}

#Preview {
    GameListView(title: "인기 게임")
        .environmentObject(AppNavigationPath())
}
