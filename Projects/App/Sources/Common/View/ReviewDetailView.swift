//
//  ReviewDetailView.swift
//  gambler
//
//  Created by 박성훈 on 2/12/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ReviewDetailView: View {
    fileprivate let reviewData: Review
    
    // 다른 파일로 빼는게 나을 것 같음
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이름")  // Id로 이름 알아내는 메서드 사용하여 나타내기
                .font(.body1M)
                .foregroundStyle(Color.gray700)
            HStack(spacing: 4) {
                Image("star")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text(String(format: "%.1f", reviewData.reviewRating))
                    .font(.caption1M)
                    .foregroundStyle(Color.primaryDefault)
                    .padding(.trailing, 4)
                Text("\(reviewData.createdDate, formatter: Self.dateformat)")
                    .font(.caption1M)
                    .foregroundStyle(Color.gray400)
            }
            
            Text(reviewData.reviewContent)
                .font(.body2M)
                .foregroundStyle(Color.gray400)
                .padding(.bottom, 8)
            
            // reviewImage를 [String]? 이 아닌 [String] 타입으로 두는 것은 어떤지?
            if let reviewImages = reviewData.reviewImage {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(reviewImages, id: \.self) { image in
                            KFImage(URL(string: image))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ReviewDetailView(reviewData: Review(id: UUID().uuidString,
                                        postId: UUID().uuidString,
                                        userId: UUID().uuidString,
                                        reviewContent: "강남역에서 엄청 가깝고 시설도 좋더라구요~ 게임도 많아서 오랫동안 있었네요! 알바생도 친절해서 좋았어요, 다음에도 선릉점으로 가려구요",
                                        reviewRating: 4.5,
                                        reviewImage: ["https://beziergames.com/cdn/shop/products/UltimateAccessoryPack_800x.png?v=1587055236"],
                                        createdDate: Date()))
}
