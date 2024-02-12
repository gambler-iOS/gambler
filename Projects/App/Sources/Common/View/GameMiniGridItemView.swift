//
//  GameMiniGridItemView.swift
//  gambler
//
//  Created by 박성훈 on 2/12/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GameMiniGridItemView: View {
    let imageURL: String
    let gameName: String
    
    var body: some View {
        gameMiniGridItemView(imageURL: self.imageURL, name: self.gameName)
    }
    
    @ViewBuilder
    func gameMiniGridItemView(imageURL: String, name: String) -> some View {
        VStack(alignment: .center, spacing: 16) {
            KFImage(URL(string: imageURL))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(.rect(cornerRadius: 8))
            
            // 이미지 로딩이 안될 때 대체 이미지 넣어야 할 듯
            
            Text("\(name)")
                .font(.body2M)
                .foregroundStyle(Color.gray700)
        }
    }
}

#Preview {
    GameMiniGridItemView(imageURL: "https://beziergames.com/cdn/shop/products/UltimateAccessoryPack_800x.png?v=1587055236", gameName: "한밤의 늑대")
}
