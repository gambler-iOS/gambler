//
//  ListItemView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ListItemView: View {
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @State private var isShowTermsOfUserView: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                listTitleView(title: "사용자 설정")
                    .font(.subHead2B)
                
                Group {
                    Text("프로필 수정")
                        .onTapGesture {
                            appNavigationPath.myPageViewPath.append(MyPageViewOptions.profileEditView)
                        }
                    
                    Text("고객센터")
                        .onTapGesture {
                            appNavigationPath.myPageViewPath.append(MyPageViewOptions.customerServiceView)
                        }
                    
                    Text("공지사항")
                        .onTapGesture {
                            appNavigationPath.myPageViewPath.append(MyPageViewOptions.announcementsView)
                        }
                    
                    Text("이용약관")
                        .onTapGesture {
                            appNavigationPath.myPageViewPath.append(MyPageViewOptions.termsOfUseView)
                        }
                }
                .font(.body1M)
                .frame(height: 48)
                
                listTitleView(title: "기타")
                    .font(.subHead2B)
                
                Group {
                    HStack {
                        Text("버전 정보")
                        Text(myPageViewModel.appVersion ?? "unknown")
                    }
                    
                    Text("개발자 정보")
                        .onTapGesture {
                            appNavigationPath.myPageViewPath.append(MyPageViewOptions.aboutDevelopersView)
                        }
                    
                    Button {
                        Task {
                            if await loginViewModel.logoutFromFirebaseAndSocial() {
                                appNavigationPath.myPageViewPath = .init()
                                myPageViewModel.toastCategory = .signOut
                                myPageViewModel.isShowingToast = true
                            }
                        }
                    } label: {
                        Text("로그아웃")
                    }
                }
                .font(.body1M)
                .frame(height: 48)
            }
            .foregroundStyle(Color.gray700)
            .navigationDestination(for: MyPageViewOptions.self) { option in
                switch option {
                case .profileEditView:
                    ProfileEditView()
                case .customerServiceView:
                    CustomerServiceView()
                case .announcementsView:
                    AnnouncementsView()
                case .termsOfUseView:
                    MyWebView(siteURL: $myPageViewModel.termsOfUserSiteURL, title: "이용약관")
                case .aboutDevelopersView:
                    MyWebView(siteURL: $myPageViewModel.developerInfoSiteURL, title: "개발자 정보")
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func listTitleView(title: String) -> some View {
        VStack {
            Text(title)
                .padding(EdgeInsets(top: 32, leading: 0, bottom: 8, trailing: 0))
        }
    }
    
    enum MyPageViewOptions: Hashable {
        case profileEditView
        case customerServiceView
        case announcementsView
        case termsOfUseView
        case aboutDevelopersView
    }
}

#Preview {
    ListItemView()
        .environmentObject(MyPageViewModel())
        .environmentObject(LoginViewModel())
        .environmentObject(AppNavigationPath())
}
