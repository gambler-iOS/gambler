//
//  RegisterView.swift
//  gambler
//
//  Created by 박성훈 on 3/8/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @State private var isDisabled: Bool = true
    @State private var nicknameText: String = ""  // 이거는 init으로 가져오자
    private let textField: String = "닉네임을 입력해주세요."
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("닉네임을 입력해주세요.")
                .font(.subHead1B)
                .foregroundStyle(Color.black)
                .padding(.vertical, 24)
            
            TextFieldView(text: $nicknameText)
            
            Spacer()
            
            CTAButton(disabled: $isDisabled, title: "다음") {
                // 유저 닉네임 받아들이기
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .modifier(BackButton())
        .navigationTitle("회원가입")
    }
}

#Preview {
    RegistrationView()
        .environmentObject(LoginViewModel())
}
