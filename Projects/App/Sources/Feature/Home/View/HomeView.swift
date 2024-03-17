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
    @ObservedObject private var eventBannerViewModel = EventBannerViewModel()
    @State private var path = NavigationPath()
    @State private var size: CGSize = .zero
    @State private var safeArea: EdgeInsets = EdgeInsets()
    @State private var isBannerDisappear: Bool = false
    @State private var headerColor: Color = .white
    
    var body: some View {
        NavigationStack(path: $appNavigationPath.homeViewPath) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    EventBannerView(eventBannerViewModel: eventBannerViewModel)
                    HomeGameGridView(title: "채영님이 좋아하실 인기게임", games: homeViewModel.popularGames)
                    BorderView()
                    HomeShopListView(title: "인기 매장", shops: homeViewModel.popularShops)
                    BorderView()
                    HomeGameCardHScrollView(title: "흥미진진 신규게임", games: homeViewModel.newGames)
                    HomeGameCategoryHScrollView(title: "종류별 Best", categoryNames: ["마피아","블러핑","가족게임","전략"])
                    HomeShopListView(title: "신규 매장", shops: homeViewModel.newShops)
                        .padding(.bottom, 50)
                    
                }
                .overlay(alignment: .top, content: {
                    HeaderView()
                        .onChange(of: isBannerDisappear) {
                            self.headerColor = isBannerDisappear == true ? .black : .white
                        }
                })
                .navigationDestination(for: Shop.self) { shop in
                    ShopDetailInfoView(shop: shop)
                }
                .navigationDestination(for: Game.self) { game in
                    GameDetailView(game: game)
                }
                .navigationDestination(for: String.self) { title in
                    if title.contains("게임") {
                        GameListView(title: title)
                    }
                }
            }
            .coordinateSpace(name: "HOMESCROLL")
            .ignoresSafeArea(.all, edges: .top)
            .onAppear {
                getSizeAndSafeArea()
            }
        }
    }
    
    private func getSizeAndSafeArea() {
        DispatchQueue.main.async {
            size = UIScreen.main.bounds.size
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let mainWindow = windowScene.windows.first {
                safeArea = EdgeInsets(top: mainWindow.safeAreaInsets.top,
                                       leading: mainWindow.safeAreaInsets.left,
                                       bottom: mainWindow.safeAreaInsets.bottom,
                                       trailing: mainWindow.safeAreaInsets.right)
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("HOMESCROLL")).minY
            let progress = minY / 300
            
            HStack(spacing: .zero) {
                Text("Gambler")
                    .font(.subHead2B)

                Spacer()

                NavigationLink {
                    Text("공지사항")
                } label: {
                    GamblerAsset.bell.swiftUIImage
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
            }
            .frame(height: 56)
            .foregroundStyle(headerColor)
            .padding(.top, safeArea.top)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            .background(content: {
                Color.white
                    .opacity(progress > -0.8 ? 0 : (-progress * 10) - 9)
            })
            .offset(y: -minY)
            .onChange(of: minY) {
                if minY <= -295 {
                    isBannerDisappear = true
                } else {
                    isBannerDisappear = false
                }
            }
        }
        .frame(height: 56)
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
        .environmentObject(AppNavigationPath())
}
