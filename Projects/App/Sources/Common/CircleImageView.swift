//
//  CircleImageView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct CircleImageView: View {
    let imageURL: String
    let size: CGFloat
    
    var body: some View {
        if let url = URL(string: imageURL) {
            KFImage(url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(Color.gray200)
                .clipShape(.circle)
        }
    }
}

#Preview {
    CircleImageView(imageURL: MyPageViewModel().user?.profileImageURL ?? "", size: 64)
}
