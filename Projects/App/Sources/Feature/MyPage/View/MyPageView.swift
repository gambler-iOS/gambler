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
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink {
                        SettingDetailView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.gray)
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
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
                            Text("성훈이")
                            Image(systemName: "apple.logo")
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Text("내 리뷰")
                            .bold()
                        Text("3개")
                        Spacer()
                        NavigationLink("더보기") {
                            ReviewListView()
                        }
                        .foregroundStyle(.secondary)
                    }
                    Divider()
                        .padding(.bottom)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                    .padding(.bottom, 30)
                    
                    HStack {
                        Text("좋아요")
                            .bold()
                        Spacer()
                        NavigationLink("더보기") {
                            LikeCategoryView()
                        }
                        .foregroundStyle(.secondary)
                    }
                    Divider()
                        .padding(.bottom)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                    .padding(.bottom)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                            Rectangle()
                                .foregroundStyle(.gray)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MyPageView()
        .environmentObject(MyPageViewModel())
}
