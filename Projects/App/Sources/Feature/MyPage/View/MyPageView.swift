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
import PhotosUI

struct MyPageView: View {
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var profileEditViewModel: ProfileEditViewModel
    
    var toastMessage: String {
        switch myPageViewModel.toastCategory {
        case .complain:
            return "신고가 완료되었어요!"
        case .signUp:
            return "회원가입이 완료되었습니다!"
        case .signOut:
            return "로그아웃이 완료되었습니다!"
        case .deleteAccount:
            return "회원탈퇴에 성공했습니다. 아쉽지만 다음에 또 만나요!"
        }
    }
    
    var currentUser: User? {
        return loginViewModel.currentUser
    }
    
    var body: some View {
        NavigationStack(path: $appNavigationPath.myPageViewPath) {
            switch loginViewModel.authState {
            case .signedOut, .creatingAccount:
                    MyPageSignedOutView()
            case .signedIn:
                ScrollView {
                    VStack(spacing: .zero) {
                        myPageHeaderView(user: currentUser)
                        
                        HStack {
                            Spacer()
                            navigationView(title: "나의 리뷰",
                                           count: "\(currentUser?.myReviewsCount ?? 0)",
                                           destination: MyReviewsView())
                            Spacer()
                            Divider()
                                .frame(width: 1, height: 44)
                                .foregroundStyle(Color.gray200)
                            Spacer()
                            navigationView(title: "좋아요",
                                           count: "\(myPageViewModel.countLike)",
                                           destination: MyLikesView())
                            Spacer()
                        }
                        .frame(height: 140)
                        .background(Color.gray50)
                        .clipShape(.rect(cornerRadius: 8))
                        ListItemView()
                            .padding(.bottom, 24)
                    }
                }
                .padding(.horizontal, 24)
                .scrollIndicators(.hidden)
                .onAppear {
                    Task {
                        await myPageViewModel.fetchReviewData()
                        myPageViewModel.fetchLikeCount()
                    }
                }
            }
        }
        .overlay {
            if myPageViewModel.isShowingToast {
                toastMessageView
                    .padding(.horizontal, 24)
            }
        }
    }
    
    @ViewBuilder
    private func myPageHeaderView(user: User?) -> some View {
        HStack(spacing: 8) {
            if myPageViewModel.profileImageChanged {
                if let data = profileEditViewModel.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 64)
                        .clipShape(.circle)
                }
            } else {
                CircleImageView(imageURL: user?.profileImageURL ?? "" , size: 64)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(user?.nickname ?? "")
                ChipView(label: "\(user?.loginPlatform.description ?? "") 로그인 완료", size: .medium)
                    .foregroundStyle(Color.gray400)
            }
            Spacer()
        }
        .padding(.vertical, 40)
    }
    
    @ViewBuilder
    private func navigationView(title: String, count: String, destination: some View) -> some View {
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
    
    private var toastMessageView: some View {
        CustomToastView(content: toastMessage)
            .offset(y: UIScreen.main.bounds.height * 0.3)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        myPageViewModel.isShowingToast = false
                    }
                }
            }
    }
}

#Preview {
    MyPageView()
        .environmentObject(MyPageViewModel())
        .environmentObject(LoginViewModel())
        .environmentObject(ProfileEditViewModel())
        .environmentObject(AppNavigationPath())
}
