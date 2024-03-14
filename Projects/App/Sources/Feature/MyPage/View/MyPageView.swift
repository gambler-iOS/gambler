//
//  MyPageView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher
import KakaoSDKAuth
import KakaoSDKCommon

struct MyPageView: View {
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var appNavigationPath: AppNavigationPath
    
#warning("로그인 플랫폼 로직 구현 필요")
    let loginPlatform: String = "카카오톡"
    
    var body: some View {
        
        // 여기서 조건이 이래서 그럼..
        // 사인인이 되니까...
        if loginViewModel.authState == .signedOut || loginViewModel.authState == .creatingAccount {
            LoginView()
                .environmentObject(loginViewModel)
                .environmentObject(appNavigationPath)
        } else {
            NavigationStack {
                ScrollView {
                    VStack(spacing: .zero) {
                        myPageHeaderView(imageURL: myPageViewModel.user.profileImageURL, nickname: myPageViewModel.user.nickname, loginPlatform: self.loginPlatform)
                        
                        HStack {
                            Spacer()
                            navigationView(title: "나의 리뷰", destination: MyReviewsView(), count: "\(User.dummyUser.myReviewsCount)")
                            Spacer()
                            Divider()
                                .frame(width: 1, height: 44)
                                .foregroundStyle(Color.gray200)
                            Spacer()
                            navigationView(title: "좋아요", destination: MyLikesView(), count: "\(User.dummyUser.myLikesCount)")
                            Spacer()
                        }
                        .frame(height: 140)
                        .background(Color.gray50)
                        .clipShape(.rect(cornerRadius: 8))
                        
                        ListItemView()
                            .environmentObject(loginViewModel)
                    }
                }
                .padding(.horizontal, 24)
                .scrollIndicators(.hidden)
            }
        }
    }
    
    @ViewBuilder
    private func myPageHeaderView(imageURL: String, nickname: String, loginPlatform: String) -> some View {
        HStack(spacing: 8) {
            CircleImageView(imageURL: imageURL, size: 64)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(nickname)
                ChipView(label: "\(loginPlatform) 로그인 완료", size: .medium)
                    .foregroundStyle(Color.gray400)
            }
            Spacer()
        }
        .padding(.vertical, 40)
    }
    
    @ViewBuilder
    private func navigationView(title: String, destination: some View, count: String) -> some View {
        NavigationLink {
            destination
        } label: {
            VStack(spacing: 8) {
                Text(count)
                    .font(.head2B)
                    .foregroundStyle(Color.primaryDefault)
                Text(title)
                    .font(.body1M)
                    .foregroundStyle(Color.gray700)
            }
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(MyPageViewModel())
        .environmentObject(LoginViewModel())
        .environmentObject(AppNavigationPath())
}
