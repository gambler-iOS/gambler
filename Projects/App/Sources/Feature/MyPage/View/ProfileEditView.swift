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
    @State private var nickName: String = ""
    @State private var email: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    #warning("임시")
    @State private var user: User = User.dummyUser
    
    var body: some View {
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
        .navigationTitle("프로필 수정")
        .modifier(BackButton())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    reply()
                } label: {
                    Text("완료")
                        .font(.body2M)
                        .foregroundStyle(Color.gray900)
                }
            }
        }
    }
    
    private func reply() {
        // 완료 동작
        presentationMode.wrappedValue.dismiss()
    }
    
    #warning("현재 Data타입을 url로 바꾸는 방법은 storage를 거치는 방법 뿐인것같아 일단은 UIImage로 처리함")
    private var profileView: some View {
        VStack {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 64, height: 64)
                    .clipShape(.circle)
            } else {
                CircleImageView(imageURL: User.dummyUser.profileImageURL, size: 64)
            }
            pickerView
                .padding(.top, 16)
        }
    }
    
    private var pickerView: some View {
        PhotosPicker(
            selection: $selectedPhoto,
            matching: .images
        ) {
            ChipView(label: "프로필 사진 수정", size: .medium)
                .foregroundStyle(Color.gray400)
        }
        .onChange(of: selectedPhoto) {
            Task {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    imageData = data
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
            profileTextField(title: "닉네임", content: $nickName)
               
            profileTextField(title: "이메일", content: $email)
        }
    }

    private func profileTextField(title: String, content: Binding<String>) -> some View {
        TitleAndBoxView(title: title)
            .overlay {
                TextField("", text: content)
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
                                       user: $user)
                            .padding(.horizontal, 16)
                        PluginCellView(image: GamblerAsset.appleLogo.swiftUIImage,
                                       social: LoginPlatform.apple,
                                       user: $user)
                            .padding(.horizontal, 16)
                        PluginCellView(image: GamblerAsset.googleLogo.swiftUIImage,
                                       social: LoginPlatform.google,
                                       user: $user)
                            .padding(.horizontal, 16)
                    }
                }
            Button {
                // 탈퇴
                Task {
                    await loginViewModel.deleteAccount()
                }
            } label: {
                ProfileButtonView(text: "회원 탈퇴하기", size: 109, isDefaultButton: true)
            }
        }
    }
}

#Preview {
    ProfileEditView()
        .environmentObject(LoginViewModel())
}
