//
//  GameListView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct GameListView: View {
    @EnvironmentObject private var gameListViewModel: GameListViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    let title: String
    private let columns: [GridItem] = Array(repeating:
            .init(.flexible(minimum: 124, maximum: 200), spacing: 17, alignment: .leading), count: 2)
    
    var body: some View {
        VStack(spacing: 12) {
            headerView(title: title, showGrid: gameListViewModel.showGrid)
                .padding(.horizontal, 24)
            ScrollView {
                Group {
                    if gameListViewModel.showGrid == true {
                        LazyVGrid(columns: columns, spacing: 24, content: {
                            ForEach(gameListViewModel.games) { game in
                                NavigationLink(value: game) {
                                    GameGridItemView(game: game)
                                }
                            }
                        })
                        .padding(.top, 24)
                    } else {
                        VStack(spacing: 24) {
                            ForEach(gameListViewModel.games) { game in
                                NavigationLink(value: game) {
                                    GameListItemView(game: game)
                                }
                                if game != gameListViewModel.games.last {
                                    Divider()
                                }
                            }
                        }
                        .padding(.top, 24)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarBackButtonHidden()
        .buttonStyle(HiddenClickAnimationButtonStyle())
        .task {
            await gameListViewModel.fetchData(title: title)
        }
    }
        
    @ViewBuilder
    private func headerView(title: String, showGrid: Bool) -> some View {
        HStack(spacing: .zero) {
            GamblerAsset.arrowLeft.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    appNavigationPath.homeViewPath.removeLast()
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
        .frame(height: 30)
    }
}

#Preview {
    NavigationStack {
        GameListView(title: "인기 게임")
            .environmentObject(AppNavigationPath())
            .environmentObject(GameListViewModel())
    }
}
