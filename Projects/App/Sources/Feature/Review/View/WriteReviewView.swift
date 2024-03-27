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
    @EnvironmentObject private var reviewViewModel: ReviewViewModel
    @EnvironmentObject private var gameDetailViewModel: GameDetailViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var reviewContent: String = ""
    @State private var rating: Double = 0.0
    @State private var disabledButton: Bool = true
    @State private var selectedPhotosData: [Data] = []
    @State private var isUploading: Bool = false
    
    @Binding var isShowingToast: Bool
    
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
                
                AddImageView(selectedPhotosData: $selectedPhotosData, topPadding: .constant(16))
                Spacer()
                CTAButton(disabled: $disabledButton, title: "완료") {
                    Task {
                        await reply()
                    }
                }
                .padding(.bottom, 24)
                
            }
            .padding(.horizontal, 24)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("Closed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .overlay {
                if isUploading {
                    ProgressView()
                        .tint(.gray400)
                }
            }
            .onReceive([self.rating].publisher.first()) { _ in
                self.updateDisabledButton()
            }
            .onReceive([self.reviewContent].publisher.first()) { _ in
                self.updateDisabledButton()
            }
            
        }
    }
    
    private func reply() async {
        Task {
            isUploading = true
            await reviewViewModel.submitReview(user: loginViewModel.currentUser,
                                               reviewableItem: reviewableItem,
                                               reviewContent: reviewContent,
                                               reviewRating: rating,
                                               images: selectedPhotosData)
            
            loginViewModel.currentUser?.myReviewsCount += 1
            if reviewableItem is Game {
                await gameDetailViewModel.updateGameAggregateReview(appendReviewRating: rating)
            } else if reviewableItem is Shop {
                
            }
            isUploading = false
            dismiss()
            withAnimation(.easeIn(duration: 0.4)) {
                isShowingToast = true
            }
        }
    }
    
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
    WriteReviewView(isShowingToast: .constant(false), reviewableItem: Shop.dummyShop)
        .environmentObject(ReviewViewModel())
        .environmentObject(LoginViewModel())
        .environmentObject(GameDetailViewModel())
}
