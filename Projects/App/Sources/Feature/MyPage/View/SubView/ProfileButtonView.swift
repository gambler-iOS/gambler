//
//  ProfileButtonView.swift
//  gambler
//
//  Created by daye on 3/4/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ProfileButtonView: View {
    let text: String
    let size: CGFloat
    let isDefaultButton: Bool
    
    var body: some View {
        if isDefaultButton {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray200)
                .foregroundStyle(Color.white)
                .frame(width: size, height: 30)
                .overlay {
                    Text(text)
                        .font(.body2M)
                        .foregroundStyle(Color.gray400)
                }
        } else {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.primaryDefault)
                .frame(width: size, height: 30)
                .overlay {
                    Text(text)
                        .font(.body2M)
                        .foregroundStyle(Color.white)
                }
        }
    }
}

#Preview {
    ProfileButtonView(text: "연결 해제", size: 84, isDefaultButton: true)
}
