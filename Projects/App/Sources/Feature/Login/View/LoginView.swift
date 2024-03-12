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
    // 여기는 회원가입 뷰를 추가할 예정이라 private 없이 진행하도록 하겠습니다!
    @EnvironmentObject var loginViewModel: LoginViewModel

    @State private var showRegisterationView: Bool = false
    
#warning("뷰 padding 수정 필요")
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                HStack {
                    Text("문구 문구 문구문구문구")
                        .font(.head1B)
                        .foregroundStyle(Color.gray900)
                        .frame(width: 166, height: 96)
                    Spacer()
                }
                .padding(.top, 123)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image("kakaoLogin")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 60)
                        .onTapGesture {
                            Task {
                                // Bool 값을 보내줘야 할 듯...
                                await loginViewModel.signInWithKakao()
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
                        .navigationDestination(isPresented: $loginViewModel.isRegisterationViewPop) {
                            RegistrationView()
                                .environmentObject(loginViewModel)
                        }
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
    }
    
}
#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
