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
    private let shopImageURL: String = ""
//    "https://search.pstatic.net/common/?src=https%3A%2F%2Fditto-phinf.pstatic.net%2F20201202_84%2F1606873241179R2svf_PNG%2Fbf530979564df524f3516cd338d37711.png&type=o&size=488x470&ttype=input"
    
    var category: MyPageViewModel.LikeCategory = .game
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            switch category {
            case .shop:
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0..<5) { _ in
                        LazyHStack {
                            ForEach(0..<2) { _ in
                                NavigationLink {
                                    // 좋아요한 가게
                                    Text("매장 상세 뷰")
                                } label: {
                                    VStack(spacing: 5) {
                                        KFImage(URL(string: shopImageURL))
                                            .resizable()
                                            .frame(width: 150, height: 150, alignment: .center)
                                        Text("레드버튼 강남점")
                                    }
                                    .padding(15)
                                }
                            }
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
                                    VStack(spacing: 5) {
                                        KFImage(URL(string: boardGameImageURL))
                                            .resizable()
                                            .frame(width: 150, height: 150, alignment: .center)
                                        Text("루미큐브")
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
    LikeListView(category: MyPageViewModel.LikeCategory.game)
}
