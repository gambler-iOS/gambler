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
    @EnvironmentObject private var navPathFinder: NavigationPathFinder
    @State private var showRegisterationView: Bool = false
    
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
                            await loginViewModel.signInWithKakao()
                            print("카카오 로그인 버튼 클릭 - authState \(loginViewModel.authState)")
                        }
                    }
                
                // 기능 확인 완료
                SignInWithAppleButton(.signIn) { request in
                    AppleAuthService.shared.handleSignInWithAppleRequest(request)
                } onCompletion: { result in
                    AppleAuthService.shared.handleSignInWithAppleCompletion(result)
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
                        }
                    }
            }
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 24)
        .onReceive(loginViewModel.$authState) { authState in
            print("Auth가 지금 바뀝니다용 \(authState)")
            if authState == .creatingAccount && loginViewModel.userSession != nil {
                self.navPathFinder.addPath(option: .regstrationView)
                print("회원가입 뷰로 이동~")
            }
        }
        .modifier(BackButton())
        .toolbar(.hidden, for: .tabBar)  // 툴바 안보이게 하기
    }
}
#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
        .environmentObject(NavigationPathFinder.shared)
}
