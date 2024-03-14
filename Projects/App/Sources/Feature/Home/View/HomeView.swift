//
//  HomeView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @StateObject private var eventBannerViewModel = EventBannerViewModel()
    @State private var path = NavigationPath()
    private let bannerImageHeight: CGFloat = 400
    
    var body: some View {
        NavigationStack(path: $appNavigationPath.homeViewPath) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    EventBannerView(eventBannerViewModel: eventBannerViewModel, bannerImageHeight: bannerImageHeight)
                        .frame(minHeight: bannerImageHeight)
                    HomeGameGridView(title: "채영님이 좋아하실 인기게임", games: homeViewModel.popularGames)
                    BorderView()
                    HomeShopListView(title: "인기 매장", shops: homeViewModel.popularShops)
                    BorderView()
                    HomeGameCardHScrollView(title: "흥미진진 신규게임", games: homeViewModel.newGames)
                    HomeGameCategoryHScrollView(title: "종류별 Best 게임", categoryNames: homeViewModel.popularGenre)
                    HomeShopListView(title: "신규 매장", shops: homeViewModel.newShops)
                        .padding(.bottom, 50)
                    
                }
                .overlay(alignment: .top, content: {
                    HeaderView()
                })
                .navigationDestination(for: Shop.self) { shop in
                    ShopDetailView(shop: shop)
                }
                .navigationDestination(for: Game.self) { game in
                    GameDetailView(game: game)
                }
                .navigationDestination(for: GameTheme.self) { genre in
                    GameListView(title: genre.koreanName)
                }
                .navigationDestination(for: String.self) { title in
                    if title.contains("게임") {
                        GameListView(title: title)
                    }
                }
                .buttonStyle(CustomButtonStyle())
            }
            .coordinateSpace(name: "HOMESCROLL")
            .ignoresSafeArea(.all, edges: .top)
        }
        .task {
            await homeViewModel.fetchData()
            await eventBannerViewModel.fetchData()
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("HOMESCROLL")).minY
            let progress = minY / 300
            
            HStack(spacing: .zero) {
                Text("Gambler")
                    .font(.subHead2B)

                Spacer()

                NavigationLink {
                    AnnouncementsView()
                } label: {
                    GamblerAsset.bell.swiftUIImage
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
            }
            .frame(height: 56)
            .foregroundStyle(minY > -290 ? .white : .black)
            .padding(.top, 40)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            .background(content: {
                Color.white
                    .opacity(progress > -0.8 ? 0 : (-progress * 10) - 9)
            })
            .offset(y: -minY)
        }
        .frame(height: 56)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray.opacity(0.3) : Color.clear)
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
        .environmentObject(AppNavigationPath())
}
