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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                listTitleView(title: "사용자 설정")
                    .font(.subHead2B)
                
                Group {
                    listBodyView(title: "프로필 수정", destination: ProfileEditView())

                    listBodyView(title: "고객센터", destination: CustomerServiceView())
                    
                    listBodyView(title: "공지사항", destination: AnnouncementsView())
                    
                    listBodyView(title: "이용약관", destination: TermsOfUseView())
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
                    
                    listBodyView(title: "개발자 정보", destination: AboutDevelopersView())
                    
                    Button {
                        Task {
                            await loginViewModel.logoutFromFirebaseAndSocial()
                        }
                    } label: {
                        Text("로그아웃")
                    }
                }
                .font(.body1M)
                .frame(height: 48)
            }
            .foregroundStyle(Color.gray700)
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
    
    @ViewBuilder
    private func listBodyView(title: String, destination: some View) -> some View {
        NavigationLink {
            destination
        } label: {
            Text(title)
        }
    }
}

#Preview {
    ListItemView()
        .environmentObject(MyPageViewModel())
        .environmentObject(LoginViewModel())
}
