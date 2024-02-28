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

struct WriteReviewView: View {
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var reviewContent: String = ""
    @State private var rating: Double = 0.0
    @State private var disabledButton: Bool = true
    
    let placeholder: String = "리뷰를 남겨주세요."
    let reviewableItem: AvailableAggregateReview
    
    var body: some View {
        GeometryReader { _ in  // 키보드에 의해 화면이 올라가는 것을 방지함
            VStack(spacing: .zero) {
                headerView(reviewableItem: reviewableItem)
                    .padding(.bottom, 24)
                
                VStack(spacing: 16) {
                    Text("소중한 후기를 들려주세요")
                        .font(.subHead2B)
                    
                    RatingView(rating: $rating, count: .constant(5))
                    TextEditorView(text: $reviewContent, placeholder: placeholder)
                }
                
                AddImageView(topPadding: .constant(16))
                Spacer()
                CTAButton(disabled: $disabledButton, title: "완료") {
                    print("완료 버튼 눌림")
                    // 해당 리뷰를 파베에 올림
                }
                .padding(.bottom, 24)
                
            }
            .padding(.horizontal, 24)
            .onReceive([self.rating].publisher.first()) { _ in
                self.updateDisabledButton()
            }
            .onReceive([self.reviewContent].publisher.first()) { _ in
                self.updateDisabledButton()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("closed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
    }
    
#warning("텍스트 에디터의 reviewContent가 바뀔 때마다 메서드를 호출하는 것은 안좋아 보임. 디바운싱이나 스로틀링을 적용하면 좋을 듯 (onReceive)")
    
    @ViewBuilder
    private func headerView(reviewableItem: AvailableAggregateReview) -> some View {
        HStack(spacing: 16) {
            if let game = reviewableItem as? Game {
                RectangleImageView(imageURL: game.gameImage, frame: 64, cornerRadius: 8)
                
                Text(game.gameName)
                    .font(.body1M)
                    .foregroundStyle(Color.gray700)
            } else if let shop = reviewableItem as? Shop {
                RectangleImageView(imageURL: shop.shopImage, frame: 64, cornerRadius: 8)
                
                Text(shop.shopName)
                    .font(.body1M)
                    .foregroundStyle(Color.gray700)
            }
            
            Spacer()
        }
    }
    
    private func updateDisabledButton() {
        self.disabledButton = rating == 0.0 || reviewContent.isEmpty
    }
}

#Preview {
    WriteReviewView(reviewableItem: Shop.dummyShop)
        .environmentObject(ReviewViewModel())
}
