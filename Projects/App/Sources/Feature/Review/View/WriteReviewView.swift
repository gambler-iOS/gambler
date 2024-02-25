//
//  WriteReviewView.swift
//  gambler
//
//  Created by 박성훈 on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct WriteReviewView: View {
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @State var isPresentedDetailView = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(reviewViewModel.dummyShops, id: \.self) { shop in
                    shopReviewCell(shop: shop)
                    
                    Divider()
                }
            }
        }
        .padding(.horizontal, 24)
        .modifier(BackButton())
        .navigationTitle("리뷰 작성")
    }
    
    @ViewBuilder
    private func shopReviewCell(shop: Shop) -> some View {
        // 16, 48
        HStack(spacing: 16) {
            RectangleImageView(imageURL: shop.shopImage, frame: 64, cornerRadius: 8)
            
            Text(shop.shopName)
                .font(.body1M)
                .foregroundStyle(Color.gray700)
            
            Spacer()
            
            Button {
                isPresentedDetailView.toggle()
            } label: {
                ChipView(label: "리뷰 작성하기", size: .medium)
                    .foregroundStyle(Color.gray400)
            }
            .fullScreenCover(isPresented: $isPresentedDetailView) {
                WriteReviewDetailView(isPresentedDetailView: $isPresentedDetailView, shop: shop)
            }
        }
    }
}

#Preview {
    WriteReviewView()
        .environmentObject(ReviewViewModel())
}
