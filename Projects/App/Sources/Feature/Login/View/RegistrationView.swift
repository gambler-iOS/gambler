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
    @State private var nicknameText: String = ""  // 이거는 init으로 가져오자
    @State private var showTermsOfUseView: Bool = false
    @State private var isDuplicated: Bool = false
    private let textField: String = "닉네임을 입력해주세요."
    
    // TODO: Toast Message

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("닉네임을 입력해주세요.")
                .font(.subHead1B)
                .foregroundStyle(Color.black)
                .padding(.vertical, 24)
            
            TextFieldView(text: $nicknameText, isDuplicated: $isDuplicated)
                .onChange(of: nicknameText) { _, _ in
                    Task {
                        if !isDuplicated && nicknameText.count >= 2 {
                            isDisabled = false
                        } else {
                            isDisabled = true
                        }
                    }
                }
            Spacer()
            
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
            self.nicknameText = "tdas"

//            self.nicknameText = AuthService.shared.dummyUser.nickname
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
