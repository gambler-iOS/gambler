//
//  LikeListView.swift
//  gambler
//
//  Created by 박성훈 on 1/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct LikeListView: View {
    private let boardGameImageURL: String = "https://cdnfile.koreaboardgames.com/_data/product/202306/15/290c9eabef38fceca833d101044eb372.jpg"
    private let shopImageURL: String = "https://lh5.googleusercontent.com/p/AF1QipMMdgVZgU7MD44VvZ3YM4Lmjf5M-6o5H9DVD5ly=w228-h228-n-k-no"
    
    var category: MyPageViewModel.LikeCategory = .game
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            switch category {
            case .shop:
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0..<5) { _ in
                        NavigationLink {
                            // 좋아요한 가게
                            Text("매장 상세 뷰")
                        } label: {
                            HStack(spacing: 5) {
                                KFImage(URL(string: shopImageURL))
                                    .resizable()
                                    .frame(width: 100, height: 100, alignment: .center)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("레드버튼 강남점")
                                        Spacer()
                                        Button {
                                            // 좋아요 리스트에서 빼기
                                        } label: {
                                            Image(systemName: "heart.fill")
                                                .foregroundStyle(.red)
                                                .padding(10)
                                        }
                                    }
                                    Text("서울특별시 강남구 테헤란로 57길")
                                    
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.red)
                                        Text("4.5")
                                    }
                                }
                            }
                            .padding(15)
                        }
                    }
                }
                
            case .game:
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0..<10) { _ in
                        LazyHStack {
                            ForEach(0..<2) { _ in
                                NavigationLink {
                                    // GameDetailView
                                    Text("게임 상세 뷰")
                                } label: {
                                    VStack(alignment: .leading, spacing: 5) {
                                        ZStack {
                                            KFImage(URL(string: boardGameImageURL))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150, alignment: .center)
                                            
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Button {
                                                        // 좋아요 리스트에서 빼기
                                                    } label: {
                                                        Image(systemName: "heart.fill")
                                                            .foregroundStyle(.red)
                                                            .padding(10)
                                                    }
                                                }
                                                Spacer()
                                            }
                                        }
                                        Text("루미큐브")
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(.red)
                                            Text("4.5")
                                            Text("인원 3 - 10명")
                                        }
                                    }
                                    .padding(15)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LikeListView(category: MyPageViewModel.LikeCategory.shop)
}
