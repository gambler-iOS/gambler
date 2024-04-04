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
    @EnvironmentObject var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var tabNum: TabSelection

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
                toastMessageView
                    .padding(.bottom, 16)
            }
            
            CTAButton(disabled: $isDisabled, title: "다음") {
                AuthService.shared.tempUser?.nickname = nicknameText
//                appNavigationPath.registTermsViewIsActive = true
                switch tabNum.selectedTab {
                case 0:
                    appNavigationPath.homeViewPath.append(LoginViewOptions.temsOfAgreeView)
                case 1:
                    appNavigationPath.mapViewPath.append(LoginViewOptions.temsOfAgreeView)
                case 2:
                    appNavigationPath.searchViewPath.append(LoginViewOptions.temsOfAgreeView)
                case 3:
                    appNavigationPath.myPageViewPath.append(LoginViewOptions.temsOfAgreeView)
                default:
                    appNavigationPath.isGoTologin = false
                }
            }
            .padding(.bottom, 24)
            
//            .navigationDestination(isPresented: $appNavigationPath.registTermsViewIsActive) {
//                RegisterTermsOfUseView()
//            }
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
                guard let user = AuthService.shared.tempUser else { return }
                self.nicknameText = user.nickname
            }
        }
    }
    
    private var backButton: some View {
        Button {
            Task {
                if await loginViewModel.deleteAndResetAuth() {
                    dismiss()
                }
            }
        } label: {
            Image("arrowLeft")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
    }
    
    private var toastMessageView: some View {
        CustomToastView(content: toastMessage)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isShowingToast = false
                    }
                }
            }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(LoginViewModel())
        .environmentObject(AppNavigationPath())
        .environmentObject(TabSelection())
}
