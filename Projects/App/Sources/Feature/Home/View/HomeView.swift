//
//  HomeView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Logo")
                    Spacer()
                    EventBannerView()
                    PopularGamesView()
                    PopularShopsView()
                }
            }
        }
        .task {
            await homeViewModel.fetchData()
        }
//        .task {
//            await homeViewModel.testCreate()
//        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
