//
//  MyPageSignedOutView.swift
//  gambler
//
//  Created by 박성훈 on 3/15/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct MyPageSignedOutView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    
    var body: some View {
        VStack(spacing: 16) {
            Text("로그인 시 사용이 가능합니다.")
                .font(.subHead2B)
                .foregroundStyle(Color.gray700)
            
            CTAButton(disabled: .constant(false), title: "로그인 하러가기") {
                Task {
                    if await loginViewModel.logoutFromFirebaseAndSocial() {
                        print("로그아웃")
                    }
                    appNavigationPath.isGoTologin = true
                }
            }
            .frame(width: 180)
            .navigationDestination(isPresented: $appNavigationPath.isGoTologin) {
                LoginView()
            }
        }
    }
}

#Preview {
    MyPageSignedOutView()
        .environmentObject(LoginViewModel())
        .environmentObject(AppNavigationPath())
}
