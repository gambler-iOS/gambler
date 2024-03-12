//
//  CheckBox.swift
//  gambler
//
//  Created by 박성훈 on 3/8/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct CheckBox: View {
    @Binding var isAgreed: Bool

    var body: some View {
        
        Button {
            print(isAgreed)
            isAgreed.toggle()
        } label: {
            if !isAgreed {
                Rectangle()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray200, lineWidth: 1.0))
            } else {
                Image("checkBox")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
            }
        }
    }
}

#Preview {
    CheckBox(isAgreed: .constant(false))
}
