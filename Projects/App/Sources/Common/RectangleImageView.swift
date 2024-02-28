//
//  RectangleImageModifier.swift
//  gambler
//
//  Created by 박성훈 on 2/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct RectangleImageView: View {
    let imageURL: String
    let frame: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        VStack {
            if let url = URL(string: imageURL) {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: frame, height: frame)
                    .clipShape(.rect(cornerRadius: cornerRadius))
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: frame, height: frame)
                    .foregroundStyle(Color.gray200)
            }
        }
    }
}

#Preview {
    RectangleImageView(imageURL: Shop.dummyShop.shopImage, frame: 64, cornerRadius: 8)
}
