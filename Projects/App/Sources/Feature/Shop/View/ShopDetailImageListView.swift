//
//  ShopDetailImageListView.swift
//  gambler
//
//  Created by cha_nyeong on 3/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ShopDetailImageListView: View {
    let shop: Shop
    @Binding var isShowingFullScreen: Bool
    @Binding var url: URL?
    
    var body: some View {
        HStack(spacing: 24) {
            if let images = shop.shopImages {
                ForEach(images) { image in
                    if let imageUrl = URL(string: image.image) {
                        KFImage(imageUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(.rect(cornerRadius: 8))
                            .onTapGesture {
                                url = imageUrl
                                isShowingFullScreen.toggle()
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 64, height: 64)
                            .foregroundStyle(Color.gray200)
                    }
                }
                Spacer()
            }
        }
    }
}

