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
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @State private var showRegisterationView: Bool = false

#warning("뷰 padding 수정 필요")
    var body: some View {
        NavigationStack(path: $appNavigationPath.loginViewPath) {
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
                                // Bool 값을 보내줘야 할 듯...
                                await loginViewModel.signInWithKakao()
                                if loginViewModel.authState == .creatingAccount {
                                    appNavigationPath.loginViewPath.append("회원가입 뷰")
                                }
                            }
                        }
                    
                    Image("appleLogin")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 60)
                        .overlay {
                            SignInWithAppleButton { request in
                                AppleAuthService.shared.requestAppleAuthorization(request)
                            } onCompletion: { result in
                                loginViewModel.handleAppleID(result)
                                
                                if loginViewModel.authState == .creatingAccount {
                                    appNavigationPath.loginViewPath.append("회원가입 뷰")
                                }
                            }
                            .blendMode(.overlay)
                        }
                    
                    Image("googleLogin")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 60)
                        .onTapGesture {
                            Task {
                                await loginViewModel.signInWithGoogle()
                                print(loginViewModel.currentUser)
                                
                                if loginViewModel.authState == .creatingAccount {
                                    appNavigationPath.loginViewPath.append("회원가입 뷰")
                                }
                            }
                        }
                }
                .padding(.bottom, 32)
                .navigationDestination(for: String.self) { _ in
                    RegistrationView()
                        .environmentObject(loginViewModel)
                        .environmentObject(appNavigationPath)
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
}
#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
        .environmentObject(AppNavigationPath())
}
