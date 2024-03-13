//
//  PluginCellView.swift
//  gambler
//
//  Created by daye on 3/4/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct PluginCellView: View {
    let image: Image
    let social: LoginPlatform
    private var isUserSocial: Bool {
        user.loginPlatform == social
    }
    
    #warning("임시")
    @Binding var user: User
   
    var body: some View {
        HStack {
            image
                .resizable()
                .frame(width: 40, height: 40)
            Text(social.description)
            Spacer()
            ProfileButtonView(text: isUserSocial ? "연결 해제" : "연결", 
                              size: isUserSocial ? 84 : 57,
                              isDefaultButton: isUserSocial)
                .onTapGesture {
                    user.loginPlatform = social
                }
        }
        .frame(height: 56)
    }
}
#Preview {
    PluginCellView(image: GamblerAsset.kakaotalkLogo.swiftUIImage, social:.apple, user: .constant(User.dummyUser))
}