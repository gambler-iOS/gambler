//
//  CTAButton.swift
//  gambler
//
//  Created by 박성훈 on 2/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct CTAButton: View {
    @State private var isTapped: Bool = false
    @Binding var disabled: Bool
    
    let title: String
    var onTapAction: (() -> Void)  // 외부에서 전달되는 클로저 프로퍼티

    private var drageGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                self.isTapped = true
            }
            .onEnded { _ in
                self.isTapped = false
                onTapAction()
            }
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .foregroundStyle(Color.white)
                .font(.body1B)
                .padding(.vertical, 16)
            Spacer()
        }
        .background(disabled ? Color.primaryDisabled : (isTapped ? Color.primaryPressed :  Color.primaryDefault))
        .clipShape(.rect(cornerRadius: 8))
        .gesture(disabled ? nil : drageGesture)
    }
}

#Preview {
    CTAButton(disabled: .constant(false), title: "다음") {
        print("버튼 눌림")
    }
}
