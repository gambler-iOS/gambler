//
//  RegisterView.swift
//  gambler
//
//  Created by 박성훈 on 3/8/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var isDisabled: Bool = true
    @State private var nicknameText: String = ""  // 이거는 init으로 가져오자
    @State private var showTermsOfUseView: Bool = false
    @State private var isDuplicated: Bool = false
    private let textField: String = "닉네임을 입력해주세요."
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("닉네임을 입력해주세요.")
                .font(.subHead1B)
                .foregroundStyle(Color.black)
                .padding(.vertical, 24)
            
            TextFieldView(text: $nicknameText, isDuplicated: $isDuplicated)
                .onChange(of: nicknameText) { _, _ in
                    Task {
                        await duplicateCheck()
                        
                        if !isDuplicated && !textField.isEmpty {
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
            }
        }
        .padding(.horizontal, 24)
        .modifier(BackButton())
        .navigationTitle("회원가입")
    }
    
    /// 닉네임 중복검사
    /// - Returns: 중복 - true / 중복 없을 시 false
    private func duplicateCheck() async {
        do {
            let user: [User] = try await FirebaseManager.shared
                .fetchWhereIsEqualToData(collectionName: "Users", field: "nickname", isEqualTo: nicknameText)
            
            isDuplicated = user.isEmpty ? false : true
        } catch {
            print("Error fetching RegistrationView : \(error.localizedDescription)")
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(LoginViewModel())
}
