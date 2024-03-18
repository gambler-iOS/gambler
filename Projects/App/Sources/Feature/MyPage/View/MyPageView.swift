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
    
    let loginPlatform: String = "카카오톡"
    
    var currentUser: User? {
        return loginViewModel.currentUser
    }
    
    var body: some View {
        if loginViewModel.authState != .signedIn {
                MyPageSignedOutView()
                    .environmentObject(loginViewModel)
                    .environmentObject(NavigationPathFinder.shared)
        } else { // SignedIn
            NavigationStack {
                ScrollView {
                    VStack(spacing: .zero) {
                        myPageHeaderView(user: currentUser)
                        
                        HStack {
                            Spacer()
                            navigationView(title: "나의 리뷰", destination: MyReviewsView(), count: "\(currentUser?.myReviewsCount ?? 0)")
                            Spacer()
                            Divider()
                                .frame(width: 1, height: 44)
                                .foregroundStyle(Color.gray200)
                            Spacer()
                            navigationView(title: "좋아요", destination: MyLikesView(), count: "\(currentUser?.myLikesCount ?? 0)")
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
//                .onAppear {
//                    setUserInViewModel()
//                }
                .scrollIndicators(.hidden)
            }
        }
    }
    
    @ViewBuilder
    private func myPageHeaderView(user: User?) -> some View {
        HStack(spacing: 8) {
            CircleImageView(imageURL: user?.profileImageURL ?? "", size: 64)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(user?.nickname ?? "")
                ChipView(label: "\(user?.loginPlatform.description ?? "") 로그인 완료", size: .medium)
                    .foregroundStyle(Color.gray400)
            }
            Spacer()
        }
        .padding(.vertical, 40)
    }
    
    private func setUserInViewModel() {
        DispatchQueue.main.async {
            myPageViewModel.user = loginViewModel.currentUser
        }
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
