//
//  MyPageView.swift
//  gambler
//
//  Created by 박성훈 on 1/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    let signInWith: String = "카카오톡"
    let appVersion: String = "1.0.1"
    let numberOfMyReviews: Int = 10
    let numberOfLikes: Int = 24
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                        NavigationLink {
                            ProfileEditView()
                        } label: {
                            if let profileImage =  myPageViewModel.user.profileImageURL {
                                KFImage(URL(string: profileImage))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                                    .clipShape(.circle)
                                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
                            }
                        }
                        .padding()
                    VStack(alignment: .leading) {
                        Text("이름")
                        Text("\(signInWith) 로그인 완료")
                            .padding(12)
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.black, lineWidth: 1.0))
                    }
                    Spacer()
                }
                
                ZStack {
                    Rectangle()
                        .frame(height: 140)
                        .foregroundStyle(.quinary)
                        .clipShape(.rect(cornerRadius: 12))
                    
                    HStack {
                        Spacer()
                        NavigationLink {
                            ReviewListView()
                        } label: {
                            VStack {
                                Text("\(numberOfMyReviews)")
                                    .foregroundStyle(.red)
                                    .font(.title)
                                    .bold()
                                Text("나의 리뷰")
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        NavigationLink {
                            LikeListView()
                        } label: {
                            VStack {
                                Text("\(numberOfLikes)")
                                    .foregroundStyle(.red)
                                    .font(.title)
                                    .bold()
                                Text("좋아요")
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                    }
                }
                
                setDetail()
            }
            
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func setDetail() -> some View {
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
                HStack {
                    Text("버전 정보")
                    Text(self.appVersion)
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
    
}

#Preview {
    MyPageView()
        .environmentObject(MyPageViewModel())
}
