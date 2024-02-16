//
//  ItemButtonSet.swift
//  gambler
//
//  Created by daye on 2/7/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import UIKit

struct ItemButtonSetView: View {
    let type: MyPageFilter
    var shop: Shop?
    var game: Game?
    @State private var heartState: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            switch type {
            case .shop:
                ShopButtonSet
            case .game:
                GameButtonSet
            }
        }.padding(.horizontal, 25)
    }
    
    private var ShopButtonSet: some View {
        return Group {
            ItemButtonView(image: GamblerAsset.phone.swiftUIImage, buttonName: "전화") {
                tappedCall()
            }
            ItemButtonView(image: heartState ? GamblerAsset.heartRed.swiftUIImage :
                        GamblerAsset.heartGray.swiftUIImage, buttonName: "찜하기") {
                tappedHeart()
            }
            ItemButtonView(image: GamblerAsset.review.swiftUIImage, buttonName: "리뷰") {
                tappedReview()
            }
        }.padding(.horizontal, 15)
    }
    
    private var GameButtonSet: some View {
        Group {
            ItemButtonView(image: heartState ? GamblerAsset.heartRed.swiftUIImage :
                        GamblerAsset.heartGray.swiftUIImage, buttonName: "찜하기") {
                tappedHeart()
            }
            ItemButtonView(image: GamblerAsset.review.swiftUIImage, buttonName: "리뷰") {
                tappedReview()
            }
        }.padding(.horizontal, 40)
    }
    
    private func tappedCall() {
        if let phoneURL = URL(string: "tel://\(String(describing: shop?.shopPhoneNumber))"),
           UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    private func tappedHeart() {
        heartState.toggle()
    }
    
    private func tappedReview() {
        
    }
}

struct ItemButtonView: View {
    let image: Image
    let buttonName: String
    let action: () -> Void
    
    var body: some View {
        return Button {
            action()
        } label: {
            HStack {
                image
                    .resizable()
                    .frame(width: 23.1, height: 23.1)
                Text(buttonName)
                    .foregroundStyle(Color.gray500)
                    .font(.body1M)
            }
        }.frame(width: 80)
    }
}

#Preview {
    ItemButtonSetView(type: .shop, shop: Shop.dummyShop)
}
