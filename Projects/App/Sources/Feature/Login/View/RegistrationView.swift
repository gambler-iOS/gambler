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
    @State private var isShowingToast = false
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
            
            TextFieldView(text: $nicknameText, isDisabled: $isDisabled, isDuplicated: $isDuplicated, isShowingToast: $isShowingToast)
            Spacer()
            
            if isShowingToast {
                Toast(message: toastMessage, show: $isShowingToast)
                    .padding(.bottom, 16)
            }
            
            CTAButton(disabled: $isDisabled, title: "다음") {
                AuthService.shared.tempUser?.nickname = nicknameText
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
                guard let user = AuthService.shared.tempUser else {
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
                    dismiss()
                    await loginViewModel.deleteAuthWithSocial()
            }
        } label: {
            Image("arrowLeft")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
    }
    
//    private var toastMessageView: some View {
//        CustomToastView(content: toastMessage)
//            .offset(y: UIScreen.main.bounds.height * 0.3)
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    withAnimation {
//                        isShowingToast = false
//                    }
//                }
//            }
//    }

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
