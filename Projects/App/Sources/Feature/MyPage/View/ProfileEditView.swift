//
//  ProfileEditView.swift
//  gambler
//
//  Created by daye on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileEditView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @EnvironmentObject private var profileEditViewModel: ProfileEditViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var tabSelection: TabSelection
    
    @State private var nickName: String = ""
    @State private var email: String = ""
    @State private var isShowingResignModal: Bool = false
    @State private var disabledCompleteButton: Bool = true
    
    var currentUser: User? {
        return loginViewModel.currentUser
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    profileView
                        .padding(24)
                    BorderView()
                    defaultInfoView
                        .padding(24)
                    BorderView()
                    pluginView
                        .padding(24)
                }
                .padding(.bottom, 60)
            }
            .onAppear {
                self.nickName = currentUser?.nickname ?? ""
                profileEditViewModel.imageData = nil
                profileEditViewModel.selectedPhoto = nil
                myPageViewModel.profileImageChanged = false
            }
            .navigationTitle("프로필 수정")
            .modifier(BackButton())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        reply()
                    } label: {
                        Text("완료")
                            .font(.body2M)
                            .foregroundStyle(disabledCompleteButton ? Color.gray200: Color.gray900)
                    }
                    .disabled(disabledCompleteButton)
                }
            }
        } .fullScreenCover(isPresented: $isShowingResignModal) {
            CustomModalView(isShowingModal: $isShowingResignModal,
                            title: "정말 탈퇴하시겠어요?",
                            content: "탈퇴 후에는 작성하신 리뷰를 수정 혹은 삭제할 수 없어요. 탈퇴 신청 전에 꼭 확인해주세요.") {
                Task {
                    loginViewModel.removeAuthStateListener()  // 어스 리스너 중지
                    if await loginViewModel.deleteAccount() {
                        myPageViewModel.toastCategory = .deleteAccount
                        myPageViewModel.isShowingToast = true
                        AuthService.shared.isLoading = false
                        tabSelection.selectedTab = 0
                        isShowingResignModal = false
                        loginViewModel.resetAuth()
                        loginViewModel.configureAuthStateChanges()  // 어스 리스너 시작
                        appNavigationPath.myPageViewPath.removeLast()
                    }
                }
            }
        }.transaction({ transaction in
            transaction.disablesAnimations = true
        })
    }
    
    private func reply() {
        Task {
            myPageViewModel.profileImageChanged = true
            appNavigationPath.mapViewPath.removeLast()
            
            if await profileEditViewModel.uploadProfileImage(user: currentUser, selectedPhoto: profileEditViewModel.selectedPhoto) {
                await loginViewModel.getUserData()
            }
        }
    }
    
    private var profileView: some View {
        VStack {
            if let data = profileEditViewModel.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 64, height: 64)
                    .clipShape(.circle)
            } else {
                CircleImageView(imageURL: currentUser?.profileImageURL ?? "" , size: 64)
            }
            pickerView
                .padding(.top, 16)
        }
        .onChange(of: profileEditViewModel.selectedPhoto) { _, _ in
            disabledCompleteButton = false
        }
    }
    
    private var pickerView: some View {
        PhotosPicker(
            selection: $profileEditViewModel.selectedPhoto,
            matching: .images
        ) {
            ChipView(label: "프로필 사진 수정", size: .medium)
                .foregroundStyle(Color.gray400)
        }
        .onChange(of: profileEditViewModel.selectedPhoto) {
            Task {
                if let data = try? await profileEditViewModel.selectedPhoto?.loadTransferable(type: Data.self) {
                    profileEditViewModel.imageData = data
                }
            }
        }
    }
    
    private var defaultInfoView: some View {
        
        VStack(alignment: .leading) {
            Text("기본 정보")
                .padding(.bottom, 24)
                .font(.subHead1B)
                .foregroundStyle(Color.gray700)
            profileTextField(title: "닉네임", name: self.nickName)
        }
    }
    
    private func profileTextField(title: String, name: String) -> some View {
        TitleAndBoxView(title: title)
            .overlay(alignment: .leading) {
                Text(name)
                    .font(.body1M)
                    .foregroundColor(.gray700)
                    .padding(.top, 28)
                    .padding(.horizontal, 16)
            }
    }
    
    private var pluginView: some View {
        VStack(alignment: .leading) {
            Text("연결된 소셜 로그인")
                .font(.subHead1B)
                .foregroundStyle(Color.gray700)
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray100)
                .frame(height: 216)
                .padding(.vertical, 24)
                .overlay {
                    VStack {
                        PluginCellView(image: GamblerAsset.kakaotalkLogo.swiftUIImage,
                                       social: LoginPlatform.kakakotalk,
                                       user: currentUser)
                        .padding(.horizontal, 16)
                        PluginCellView(image: GamblerAsset.appleLogo.swiftUIImage,
                                       social: LoginPlatform.apple,
                                       user: currentUser)
                        .padding(.horizontal, 16)
                        PluginCellView(image: GamblerAsset.googleLogo.swiftUIImage,
                                       social: LoginPlatform.google,
                                       user: currentUser)
                        .padding(.horizontal, 16)
                    }
                }
            Button {
                isShowingResignModal = true
            } label: {
                ProfileButtonView(text: "회원 탈퇴하기", width: 109, height: 30, isDefaultButton: true, isDisabled: false)
            }
        }
    }
}

#Preview {
    ProfileEditView()
        .environmentObject(LoginViewModel())
        .environmentObject(MyPageViewModel())
        .environmentObject(ProfileEditViewModel())
        .environmentObject(AppNavigationPath())
}
