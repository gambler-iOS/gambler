//
//  HomeGameCategoryHScrollView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeGameGenreHScrollView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    let title: String
    let genres: [GameGenre]

    var body: some View {
        VStack(spacing: 24) {
            SectionHeaderView(title: title)
                .onTapGesture {
                    appNavigationPath.homeViewPath.append(title)
                }
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(genres, id: \.self) { genre in
                        NavigationLink(value: genre) {
                            GameGenreCellView(genre: genre)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(Color.gray50)
    }
}

#Preview {
    HomeGameGenreHScrollView(title: "종류별 Best", genres: [.fantasy, .bluffing])
        .environmentObject(AppNavigationPath())
}
