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
    @State private var disabledButton: Bool = true
    @Binding var isPresentedDetailView: Bool
    let shop: Shop
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: .zero) {
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
                
                StarRatingView($rating, maxRating: 5)
                
                TextEditorView(reviewContent: $reviewContent)
                
                AddImageView()
            }
            Spacer()
            
            // 완료버튼
            CTAButton(disabled: $disabledButton, title: "완료") {
                print("완료 버튼 눌림")
                // 해당 리뷰를 파베에 올림
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .onReceive([self.rating].publisher.first()) { _ in // rating이 변경될 때마다 호출
            self.updateDisabledButton() // disabledButton 업데이트
        }
        .onReceive([self.reviewContent].publisher.first()) { _ in // reviewContent가 변경될 때마다 호출
            self.updateDisabledButton() // disabledButton 업데이트
        }
        #warning("텍스트 에디터의 reviewContent가 바뀔 때마다 메서드를 호출하는 것은 안좋아 보임. 디바운싱이나 스로틀링을 적용하면 좋을 듯")
    }
    
    private func updateDisabledButton() {
        self.disabledButton = rating == 0.0 || reviewContent.isEmpty
    }
}

#Preview {
    WriteReviewDetailView(isPresentedDetailView: .constant(true), shop: Shop.dummyShop)
        .environmentObject(ReviewViewModel())
}
