//
//  ProfileEditView.swift
//  gambler
//
//  Created by daye on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ProfileEditView: View {
    
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
            .padding(.vertical, 127)
        }
        .navigationTitle("프로필 수정")
        .modifier(BackButton())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
               Text("완료")
                    .font(.body2M)
            }
        }
    }
    
    private var profileView: some View {
        VStack {
            CircleImageView(imageURL: User.dummyUser.profileImageURL, size: 64)
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
            TitleAndBoxView(title: "닉네임")
            TitleAndBoxView(title: "이메일")
        }
    }

    private var pluginView: some View {
        VStack(alignment: .leading) {
            Text("기본 정보")
                .padding(.bottom, 24)
                .font(.subHead1B)
                .foregroundStyle(Color.gray700)
            VStack {
                pluginCellView(image: User.dummyUser.profileImageURL, socialName: "카카오톡")
                    .padding(.horizontal, 16)
                pluginCellView(image: User.dummyUser.profileImageURL, socialName: "Apple")
                    .padding(.horizontal, 16)
                pluginCellView(image: User.dummyUser.profileImageURL, socialName: "Google")
                    .padding(.horizontal, 16)
            }
            .padding(.vertical, 24)
            .background {
                Rectangle()
                    .stroke(lineWidth: 1)
                    .cornerRadius(8)
                    .foregroundColor(Color.gray100)
                    .frame(height: 216)
            }
        }
    }
    
    private func pluginCellView(image: String, socialName: String) -> some View {
        HStack {
            CircleImageView(imageURL: image, size: 40)
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
