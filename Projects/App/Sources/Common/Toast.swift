//
//  ToasMessage.swift
//  gambler
//
//  Created by 박성훈 on 3/15/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct Toast: View {
    let message: String
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(message)
                    .font(.body2M)
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .padding(.vertical, 12)
            .background(Color.gray500)
            .clipShape(Capsule())
        }
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                self.show = false
            }
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.show = false
                }
            }
        })
    }
}
