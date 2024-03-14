//
//  TermsOfUseView.swift
//  gambler
//
//  Created by 박성훈 on 3/8/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct RegisterTermsOfUseView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @State private var isDisabled: Bool = true
    @State private var agreedAll: Bool = false
    @State private var agreedFirstItem: Bool = false
    @State private var agreedSecondItem: Bool = false
    
    var body: some View {
        VStack(spacing: .zero) {
            Text("이용약관에 동의해주세요.")
                .font(.subHead1B)
                .foregroundStyle(Color.black)
                .padding(.bottom, 32)
            
            termosOfUse(isAgreed: $agreedAll, title: "전체동의")
            Divider()
                .padding(.bottom, 24)
                .onChange(of: agreedAll) { _, newValue in
                    if newValue {
                        agreedFirstItem = true
                        agreedSecondItem = true
                    } else {
                        agreedFirstItem = false
                        agreedSecondItem = false
                    }
                }
            
            termosOfUse(isAgreed: $agreedFirstItem, title: "이용약관 동의(필수)")
            termosOfUse(isAgreed: $agreedSecondItem, title: "개인정보 수집 및 이용동의(필수)")
                .onChange(of: agreedFirstItem) { _, newValue in
                    if !newValue {
                        agreedAll = false
                    }
                    
                    if newValue && agreedSecondItem {
                        agreedAll = true
                        isDisabled = false
                    } else {
                        isDisabled = true
                    }
                }
                .onChange(of: agreedSecondItem) { _, newValue in
                    if !newValue {
                        agreedAll = false
                    }
                    
                    if newValue && agreedFirstItem {
                        agreedAll = true
                        isDisabled = false
                    } else {
                        isDisabled = true
                    }
                }
            
            Spacer()
            CTAButton(disabled: $isDisabled, title: "회원가입 완료") {
                // 회원가입 완료
                // 1. Auth에 등록
                // 2. Firestore에 올리기
                // 3. 로그인하기
//                guard let user = loginViewModel.dummyUser else {
//                    print(#fileID, #function, #line, "- 회원가입 실패 ")
//                    return
//                }
                
                AuthService.shared.uploadUserToFirestore(user: AuthService.shared.dummyUser)
                loginViewModel.authState = .signedIn
                
                // TODO: 루트뷰 가기
//                    .onTapGesture {
//                        appNavigationPath.loginViewPath.removeLast()
//                    }
                // 루트뷰로 가야함
                // 이렇게 만들고 코드 대폭 수정해야 함....
                // 어쨌든 마이페이지 뷰가 보인다는 것은 signIn이 되었다가 firstSignin이 된다는 것,, 문제 많다
                appNavigationPath.loginViewPath = .init()
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .modifier(BackButton())
        .navigationTitle("회원가입")
    }
    
    @ViewBuilder
    private func termosOfUse(isAgreed: Binding<Bool>, title: String) -> some View {
        HStack(spacing: 8) {
            CheckBox(isAgreed: isAgreed)
            Text(title)
                .font(.body1B)
                .foregroundStyle(Color.black)
            Spacer()
        }
        .padding(.vertical, 16)
    }
    
}

#Preview {
    RegisterTermsOfUseView()
        .environmentObject(LoginViewModel())
}
