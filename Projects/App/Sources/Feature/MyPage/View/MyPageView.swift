//
//  MyPageView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack(spacing: 8) {
                    if let profileImage =  myPageViewModel.user.profileImageURL {
                        KFImage(URL(string: profileImage))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 64, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.gray)
                            .clipShape(.circle)
                            .overlay(Circle().stroke(Color.green, lineWidth: 2))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("이름")
//                        Text("\(signInWith) 로그인 완료")
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
//                            ReviewListView()
                        } label: {
                            VStack {
//                                Text("\(numberOfMyReviews)")
//                                    .foregroundStyle(.red)
//                                    .font(.title)
//                                    .bold()
                                Text("나의 리뷰")
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        NavigationLink {
//                            LikeCategoryView()
                        } label: {
                            VStack {
//                                Text("\(numberOfLikes)")
//                                    .foregroundStyle(.red)
//                                    .font(.title)
//                                    .bold()
                                Text("좋아요")
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                    }
                }
                ListItemView()
            }
        }
        .padding(.horizontal)
    }
    
}

#Preview {
    MyPageView()
        .environmentObject(MyPageViewModel())
}
