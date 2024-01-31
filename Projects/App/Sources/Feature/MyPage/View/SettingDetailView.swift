//
//  SettingDetailView.swift
//  gambler
//
//  Created by 박성훈 on 1/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct SettingDetailView: View {
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("사용자 설정")
                        .bold()
                    NavigationLink {
                        ProfileEditView()
                    } label: {
                        Text("프로필 수정")
                            .foregroundStyle(.black)
                    }

                    NavigationLink {
                        Text("알림 설정 뷰")
                    } label: {
                        Text("알림 설정")
                            .foregroundStyle(.black)
                    }
                    .padding(.bottom, 15)
                    
                    Text("이용안내")
                        .bold()
                    
                    NavigationLink {
                        Text("신고하기 뷰")
                    } label: {
                        Text("신고하기")
                            .foregroundStyle(.black)
                    }

                    NavigationLink {
                        Text("공지사항 뷰")
                    } label: {
                        Text("공지사항")
                            .foregroundStyle(.black)
                    }

                    NavigationLink {
                        Text("이용약관 뷰")
                    } label: {
                        Text("이용약관")
                            .foregroundStyle(.black)
                    }
                    .padding(.bottom, 15)
                    
                    Text("기타")
                        .bold()
                    NavigationLink {
                        Text("버전 정보")
                    } label: {
                        Text("버전 정보")
                            .foregroundStyle(.black)
                    }
                    
                    NavigationLink {
                        Text("개발자 정보 뷰")
                    } label: {
                        Text("개발자 정보")
                            .foregroundStyle(.black)
                    }

                    Button {
                        // 로그아웃
                    } label: {
                        Text("로그아웃")
                            .foregroundStyle(.orange)
                    }
                    .padding(.bottom, 15)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("설정")
    }
}

#Preview {
    SettingDetailView()
}
