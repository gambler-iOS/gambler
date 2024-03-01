//
//  ProfileEditView.swift
//  gambler
//
//  Created by daye on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ProfileEditView: View {
    @State private var nickName: String = ""
    @State private var email: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                profileView
                    .padding(32)
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
                }

            }
        }
    }
    
    private func reply() {
        // 완료 동작
    }
    
    private var profileView: some View {
        VStack {
            CircleImageView(imageURL: User.dummyUser.profileImageURL, size: 64)
                .padding(.bottom, 16)
            ChipView(label: "프로필 사진 수정", size: .medium)
                .foregroundStyle(Color.gray400)
                
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
                        pluginCellView(image: GamblerAsset.kakaotalkLogo.swiftUIImage, socialName: "카카오톡")
                            .padding(.horizontal, 16)
                        pluginCellView(image: GamblerAsset.appleLogo.swiftUIImage, socialName: "Apple")
                            .padding(.horizontal, 16)
                        pluginCellView(image: GamblerAsset.googleLogo.swiftUIImage, socialName: "Google")
                            .padding(.horizontal, 16)
                    }
                }
            Rectangle()
                .frame(width: 57, height: 30)
                .cornerRadius(8)
        }
    }
    
    private func pluginCellView(image: Image, socialName: String) -> some View {
        HStack {
            image
                .resizable()
                .frame(width: 40, height: 40)
            Text(socialName)
            Spacer()
            Rectangle()
                .frame(width: 57, height: 30)
                .cornerRadius(8)
        }
        .frame(height: 56)
    }
    
}

#Preview {
    ProfileEditView()
}
