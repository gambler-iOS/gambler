//
//  WriteReviewDetailView.swift
//  gambler
//
//  Created by 박성훈 on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct WriteReviewDetailView: View {
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @State private var reviewContent: String = ""
    @State private var rating = 0.0
    @Binding var isPresentedDetailView: Bool
    let shop: Shop
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: .zero) {
            // x 버튼
            VStack(spacing: .zero) {
                Button {
                    isPresentedDetailView.toggle()
                } label: {
                    Image("closed")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .frame(height: 56)
            
            HStack(spacing: 16) {
                if let url = URL(string: shop.shopImage) {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(.rect(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 64, height: 64)
                        .foregroundStyle(Color.gray200)
                }
                
                Text(shop.shopName)
                    .font(.body1M)
                    .foregroundStyle(Color.gray700)
                
                Spacer()
            }
            .padding(.bottom, 24)
            
            VStack(spacing: 16) {
                Text("소중한 후기를 들려주세요")
                    .font(.subHead2B)
                
//                Text("Rating: \(String(format: "%.1f", rating))")
                // 수정하긴 해야 함
                StarRatingView($rating, maxRating: 5)
                
                TextEditorView(reviewContent: $reviewContent)
                
                AddImageView()
            }
            Spacer()
            
            // 완료버튼
        }
        .padding(.horizontal, 24)
    }
    
}



#Preview {
    WriteReviewDetailView(isPresentedDetailView: .constant(true), shop: Shop.dummyShop)
        .environmentObject(ReviewViewModel())
}
