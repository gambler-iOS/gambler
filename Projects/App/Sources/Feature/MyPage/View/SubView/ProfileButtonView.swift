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
    let width: CGFloat
    let height: CGFloat
    let isDefaultButton: Bool
    //30
    var body: some View {
        if isDefaultButton {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray200)
                .foregroundStyle(Color.white)
                .frame(width: width, height: height)
                .overlay {
                    Text(text)
                        .font(.body2M)
                        .foregroundStyle(Color.gray400)
                }
        } else {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.primaryDisabled)
                .frame(width: width, height: height)
                .overlay {
                    Text(text)
                        .font(.body2M)
                        .foregroundStyle(Color.white)
                }
        }
    }
}

#Preview {
    ProfileButtonView(text: "연결 해제", width: 84, height: 30, isDefaultButton: true)
}
