//
//  LoginView.swift
//  gambler
//
//  Created by 박성훈 on 3/4/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
#warning("뷰 padding 수정 필요")
    var body: some View {
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
                            await loginViewModel.signInWithKakao()
                        }
                    }
                
                Image("appleLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 60)
                    .onTapGesture {
                        // 애플 로그인
                    }
                
                Image("googleLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 60)
                    .onTapGesture {
                        loginViewModel.signInWithGoogle()
                    }
            }
            .padding(.bottom, 56)
            
            HStack {
                Text("이미 가입하셨나요?")
                Text("로그인")
                    .underline()
            }
            .foregroundStyle(Color.gray600)
            .padding(.bottom, 24)
            
        }
        .padding(.horizontal, 24)
    }
    
}
#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
