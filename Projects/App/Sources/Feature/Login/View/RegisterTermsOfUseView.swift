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
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @EnvironmentObject private var tabSelection: TabSelection
    @Environment(\.dismiss) private var dismiss
    
    @State private var isDisabled: Bool = true
    @State private var agreedAll: Bool = false
    @State private var agreedFirstItem: Bool = false
    @State private var agreedSecondItem: Bool = false
    @State private var termsOfUserSafariActive = false
    @State private var personalInformationSafariActive = false
    
    private let personalInformationLink: String = "https://raw.githubusercontent.com/gambler-iOS/gambler-WebPage/main/Pricacy.md"
    
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
                guard let user = AuthService.shared.tempUser else {
                    print("더미유저 없음 회원가입 실패")
                    return
                }
                
                Task {
                    myPageViewModel.toastCategory = .signUp
                    myPageViewModel.isShowingToast = true
                    switch tabSelection.selectedTab {
                    case 0:
                        appNavigationPath.homeViewPath.removeLast(3)
                    case 1:
                        appNavigationPath.mapViewPath.removeLast(3)
                    case 2:
                        appNavigationPath.searchViewPath.removeLast(3)
                    case 3:
                        appNavigationPath.myPageViewPath.removeLast(3)
                    default:
                        appNavigationPath.isGoTologin = false
                    }
                    
//                    appNavigationPath.returnToPreLogin()  // 여기서 로그인 뷰로 이동(뒤로 이동 한 번 더?)
//                    myPageViewPath.removeLast()
                    AuthService.shared.uploadUserToFirestore(user: user)
                    await loginViewModel.fetchUserData()
                    loginViewModel.authState = .signedIn
                    withAnimation(.easeIn(duration: 0.4)) {
                        myPageViewModel.isShowingToast = true
                    }
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        switch tabSelection.selectedTab {
//                        case 0:
//                            dismiss()
//                        case 1:
//                            dismiss()
//                        case 2:
//                            dismiss()
//                        case 3:
//                            dismiss()
//                        default:
//                            appNavigationPath.isGoTologin = false
//                        }
//                    }
                }
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .modifier(BackButton())
        .navigationTitle("회원가입")
        .sheet(isPresented: $termsOfUserSafariActive) {
            WebView(siteURL: myPageViewModel.termsOfUserSiteURL)
        }
        .sheet(isPresented: $personalInformationSafariActive) {
            WebView(siteURL: personalInformationLink)
        }
    }
    
    @ViewBuilder
    private func termosOfUse(isAgreed: Binding<Bool>, title: String) -> some View {
        HStack(spacing: 8) {
            CheckBox(isAgreed: isAgreed)
            Text(title)
                .font(.body1B)
                .foregroundStyle(Color.black)
                .overlay(
                    title != "전체동의" ?
                    Rectangle()
                        .frame(height: 1)
                        .offset(y: 4)
                    : nil,
                    alignment: .bottom)
                .onTapGesture {
                    if title == "이용약관 동의(필수)" {
                        termsOfUserSafariActive = true
                    } else if title == "개인정보 수집 및 이용동의(필수)" {
                        personalInformationSafariActive = true
                    }
                }
            Spacer()
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    RegisterTermsOfUseView()
        .environmentObject(LoginViewModel())
        .environmentObject(AppNavigationPath())
        .environmentObject(MyPageViewModel())
}
