//
//  LoginView.swift
//  gambler
//
//  Created by 박성훈 on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                Image("Kakao")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 60)
                    .onTapGesture {
                        Task {
                            await authViewModel.signInWithKakao()
                        }
                    }
                
                Image("Apple")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 60)
                    .onTapGesture {
                        // 애플 로그인
                    }
                
                Image("Google")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 60)
                    .onTapGesture {
                        authViewModel.signInWithGoogle()
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
        .environmentObject(AuthViewModel())
}
