//
//  RegisterView.swift
//  gambler
//
//  Created by 박성훈 on 3/8/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var isDisabled: Bool = true
    @State private var nicknameText: String = ""
    @State private var showTermsOfUseView: Bool = false
    @State private var isDuplicated: Bool = false
    @State private var showToast = false
    private let textField: String = "닉네임을 입력해주세요."
    private var toastMessage: String {
        isDuplicated ? "아이디가 중복됩니다. 다시 입력해주세요!": "아이디 중복확인이 완료되었습니다!"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("닉네임을 입력해주세요.")
                .font(.subHead1B)
                .foregroundStyle(Color.black)
                .padding(.vertical, 24)
            
            TextFieldView(text: $nicknameText, isDisabled: $isDisabled, isDuplicated: $isDuplicated, showToast: $showToast)
            Spacer()
            
            if showToast {
                Toast(message: toastMessage, show: $showToast)
                    .padding(.bottom, 16)
            }
            
            CTAButton(disabled: $isDisabled, title: "다음") {
                // 유저 닉네임 받아들이기
                loginViewModel.currentUser?.nickname = nicknameText
                showTermsOfUseView.toggle()
            }
            .padding(.bottom, 24)
            .navigationDestination(isPresented: $showTermsOfUseView) {
                RegisterTermsOfUseView()
                    .environmentObject(loginViewModel)
                    .environmentObject(appNavigationPath)
            }
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .navigationTitle("회원가입")
        .onAppear {
            self.nicknameText = AuthService.shared.dummyUser.nickname
        }        
    }
    
    private var backButton: some View {
        Button {
            Task {
                do {
                    dismiss()
                    try await loginViewModel.signOut()
                } catch {
                    print("로그아웃 실패 Error: \(error)")
                }
            }
        } label: {
            Image("arrowLeft")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(LoginViewModel())
        .environmentObject(AppNavigationPath())
}
