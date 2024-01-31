//
//  MainView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 12/31/23.
//  Copyright © 2023 gambler. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @State private var myPageViewModel = MyPageViewModel()
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        if loginViewModel.signState == .signIn {
            mainView()
                .onAppear {
                    if Auth.auth().currentUser != nil {
                        loginViewModel.signState = .signIn
                    }
                }
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    private func mainView() -> some View {
        TabView {
            Text("홈")
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            Text("내주변")
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                    Text("내주변")
                }
            Text("검색")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("검색")
                }
            MyPageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이페이지")
                }
                .environmentObject(myPageViewModel)
        }
    }
    
}

#Preview {
    MainView()
}
