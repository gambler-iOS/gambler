//
//  ReviewViewModel.swift
//  gambler
//
//  Created by 박성훈 on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

final class ReviewViewModel: ObservableObject {
    
    @Published var dummyReviews: [Review] = []
    
    init() {
        generateDummyData()
    }
    
    private func generateDummyData() {
        for _ in 1...7 {
            dummyReviews.append(Review(id: UUID().uuidString,
                                       postId: UUID().uuidString,
                                       userId: UUID().uuidString,
                                       reviewContent: "친구 3명이랑 했는데 일반 마피아보다 색달라서 재밌었어요. 쉬운 게임이여서 진입장벽 없이 바로 할 수 있음요 ~!",
                                       reviewRating: 4.0,
                                       reviewImage: ["https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186"],
                                       createdDate: Date()
 ))
        }
    }
}
