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

    @State private var isShowingToast: Bool = false
    
    var currentUser: User? {
        return loginViewModel.currentUser
    }
    
    var body: some View {
        if loginViewModel.authState != .signedIn {
                MyPageSignedOutView()
        } else { // SignedIn
            NavigationStack {
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
                                           count: "\(currentUser?.myLikesCount ?? 0)",
                                           destination: MyLikesView())
                            Spacer()
                        }
                        .frame(height: 140)
                        .background(Color.gray50)
                        .clipShape(.rect(cornerRadius: 8))
                        .onAppear {
                            Task {
                                await myPageViewModel.fetchReviewData()
                            }
                        }
                        
                        ListItemView(isShowingToast: $isShowingToast)
                    } .overlay {
                        if isShowingToast {
                            toastMessageView
                        }
                    }
                   
                }
                .padding(.horizontal, 24)
                .scrollIndicators(.hidden)
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
        CustomToastView(content: "신고가 완료되었어요!")
            .offset(y: UIScreen.main.bounds.height * 0.3)
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
    MyPageView()
        .environmentObject(MyPageViewModel())
        .environmentObject(LoginViewModel())
        .environmentObject(ProfileEditViewModel())
        .environmentObject(AppNavigationPath())
}
