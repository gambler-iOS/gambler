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
                
                // TODO: 팀계정 연결 후 애플 로그인 구현
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
                        Task {
                            await loginViewModel.signInWithGoogle()
                        }
                    }
            }
            .padding(.bottom, 56)
            
        }
        .padding(.horizontal, 24)
    }
    
}
#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
