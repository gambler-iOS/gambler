//
//  FullScreenImageView.swift
//  gambler
//
//  Created by cha_nyeong on 3/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct FullScreenImageView: View {
    @Binding var isShowingFullScreen: Bool
    @Binding var url: URL?

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            KFImage(url)
                .resizable()
                .aspectRatio(contentMode: .fit)

            Button {
                withAnimation {
                    isShowingFullScreen = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .padding()
            .position(x: 50, y: 50)
        }
    }
}
