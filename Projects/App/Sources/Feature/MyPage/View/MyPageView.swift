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
                    CircleImageView(imageURL: myPageViewModel.user.profileImageURL, size: 64)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("이름")
                        //                        Text("\(signInWith) 로그인 완료")
                            .padding(12)
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.black, lineWidth: 1.0))
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    navigationView(title: "나의 리뷰", destination: MyReviewsView(), count: myPageViewModel.numnberOfReviews)
                    Spacer()
                    Divider()
                        .frame(width: 1, height: 44)
                        .foregroundStyle(Color.gray200)
                    Spacer()
                    navigationView(title: "좋아요", destination: MyLikesView(), count: myPageViewModel.numberOfLikes)
                    Spacer()
                }
                .frame(height: 140)
                .background(Color.gray50)
                .clipShape(.rect(cornerRadius: 8))
                
                ListItemView()
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func navigationView(title: String, destination: some View, count: String) -> some View {
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
    
}

#Preview {
    MyPageView()
        .environmentObject(MyPageViewModel())
}
