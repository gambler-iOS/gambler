//
//  TabBarView.swift
//  gambler
//
//  Created by cha_nyeong on 2/14/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

final class TabSelection: ObservableObject {
    @Published var selectedTab = 0
    
    func goToHomeTab() {
        selectedTab = 0
    }
}

struct TabBarView: View {
    @EnvironmentObject private var tabSelection: TabSelection
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @State private var draw = false
    
    var body: some View {
        TabView(selection: $tabSelection.selectedTab) {
            Group {
                HomeView()
                    .tabItem {
                        HStack {
                            (tabSelection.selectedTab == 0 ?
                             GamblerAsset.tabHomeSelected.swiftUIImage : GamblerAsset.tabHome.swiftUIImage)
                            Text("홈")
                        }
                    }
                    .tag(0)
                
                MapView(draw: $draw)
                    .tabItem {
                        HStack {
                            (tabSelection.selectedTab == 1 ?
                             GamblerAsset.tabMapSelected.swiftUIImage : GamblerAsset.tabMap.swiftUIImage)
                            Text("내 주변")
                            
                        }
                    }
                    .tag(1)
                SearchMainView(searchBoxController:
                                MultiController.controller.searchBoxController,
                               shopHitsController: MultiController.controller.shopHitsController,
                               gameHitsController: MultiController.controller.gameHitsController,
                               shopStatsController: MultiController.controller.shopStatsController, gameStatsController: MultiController.controller.gameStatsController
                )
                .tabItem {
                    HStack {
                        (tabSelection.selectedTab == 2 ?
                         GamblerAsset.tabSearchSelected.swiftUIImage : GamblerAsset.tabSearch.swiftUIImage)
                        Text("검색")
                    }
                }
                .tag(2)
                
                MyPageView()
                    .tabItem {
                        HStack {
                            (tabSelection.selectedTab == 3 ?
                             GamblerAsset.tabProfileSelected.swiftUIImage : GamblerAsset.tabProfile.swiftUIImage)
                            Text("마이")
                        }
                    }
                    .tag(3)
            }
            .overlay {
                if myPageViewModel.isShowingToast {
                    toastMessageView
                        .padding(.horizontal, 24)
                }
            }
        }
        .tint(Color.primaryDefault)
        .onAppear {
            self.draw = true
        }
        .onDisappear {
            self.draw = false
        }
    }
    
    private var toastMessageView: some View {
        
        var toastMessage: String {
            switch myPageViewModel.toastCategory {
            case .complain:
                return "신고가 완료되었어요!"
            case .signUp:
                return "회원가입이 완료되었습니다!"
            case .signOut:
                return "로그아웃이 완료되었습니다!"
            case .deleteAccount:
                return "회원탈퇴에 성공했습니다. 아쉽지만 다음에 또 만나요!"
            }
        }
        
        return CustomToastView(content: toastMessage)
            .offset(y: UIScreen.main.bounds.height * 0.3)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        myPageViewModel.isShowingToast = false
                    }
                }
            }
    }
}

#Preview {
    TabBarView()
        .environmentObject(TabSelection())
}
