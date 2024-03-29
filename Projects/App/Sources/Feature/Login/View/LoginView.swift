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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    
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
                Image("logo")
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
        .onChange(of: loginViewModel.authState) { _, newAuth in
            if newAuth == .creatingAccount && loginViewModel.userSession != nil {
                appNavigationPath.loginViewPath.append(LoginViewOptions.regstrationView)
            }
        }
        .onChange(of: loginViewModel.authState) { _, newValue in
            if newValue == .signedIn {
                dismiss()
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
