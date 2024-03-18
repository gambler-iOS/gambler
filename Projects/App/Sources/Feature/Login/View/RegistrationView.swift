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
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject private var navPathFinder: NavigationPathFinder
    
    @State private var isDisabled: Bool = true
    @State private var nicknameText: String = ""
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
                loginViewModel.currentUser?.nickname = nicknameText
                navPathFinder.addPath(option: .temsOfAgreeView)
            }
            .padding(.bottom, 24)
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
            Task {
                await loginViewModel.fetchUserData()
                
                guard let user = AuthService.shared.dummyUser else {
                    print("DummyUser 없음 - 가져오기 실패")
                    return
                }
                self.nicknameText = user.nickname
            }
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
        .environmentObject(NavigationPathFinder.shared)
}
