//
//  LoginView.swift
//  gambler
//
//  Created by 박성훈 on 3/4/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
//    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var tabNum: TabSelection
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("GAMBLER")
                        .foregroundStyle(Color.primaryDefault)
                    Text("주변 보드게임을")
                    Text("한 손에!")
                        .foregroundStyle(Color.gray900)
                }
                .font(.head1B)
                Spacer()
            }
            .padding(.top, 71)  // 비율이 있는지..?
            Spacer()
            
            HStack {
                Spacer()
                Image("DiceLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 254, height: 203)
                    .padding(.bottom, 42)
            }
            
            VStack(spacing: 16) {
                Image("kakaoLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 60)
                    .onTapGesture {
                        Task {
                            await KakaoAuthService.shared.signInWithKakao()
                        }
                    }
                
                Image("appleLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 60)
                    .overlay {
                        SignInWithAppleButton { request in
                            AppleAuthService.shared.handleSignInWithAppleRequest(request)
                        } onCompletion: { result in
                            AppleAuthService.shared.handleSignInWithAppleCompletion(result)
                        }
                        .blendMode(.overlay)
                    }
                
                Image("googleLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 60)
                    .onTapGesture {
                        Task {
                            await GoogleAuthSerVice.shared.signInWithGoogle()
                        }
                    }
            }
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 24)
        .navigationDestination(isPresented: $appNavigationPath.registViewIsActive) {
            RegistrationView()
        }
        .onChange(of: loginViewModel.authState) { _, newAuth in
            if newAuth == .creatingAccount && loginViewModel.userSession != nil {
                appNavigationPath.registViewIsActive = true
            }
        }
        .onChange(of: loginViewModel.authState) { _, newValue in
            if newValue == .signedIn {
                switch tabNum.selectedTab {
                case 0:
                    appNavigationPath.homeViewPath.removeLast()
                case 1:
                    appNavigationPath.mapViewPath.removeLast()
                case 2:
                    appNavigationPath.searchViewPath.removeLast()
                case 3:
                    appNavigationPath.myPageViewPath.removeLast()
                default:
                    appNavigationPath.isGoTologin = false
                }
            }
        }
        .modifier(BackButton())
        .modifier(CustomLoadingView(isLoading: AuthService.shared.isLoading))
        .toolbar(.hidden, for: .tabBar)
    }
}
#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
        .environmentObject(AppNavigationPath())
}
