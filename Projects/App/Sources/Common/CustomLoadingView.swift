//
//  CustomLoadingView.swift
//  gambler
//
//  Created by 박성훈 on 3/26/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct CustomLoadingView: AnimatableModifier {
    var isLoading: Bool
    
    init(isLoading: Bool, color: Color = .primary, lineWidth: CGFloat = 3) {
        self.isLoading = isLoading
    }
    
    var animatableData: Bool {
        get { isLoading }
        set { isLoading = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                GeometryReader { geometry in
                    ZStack(alignment: .center) {
                        content
                            .disabled(self.isLoading)
                            .blur(radius: self.isLoading ? 3 : 0)
                        
                        ProgressView {
                            Text("Loading...")
                        }
                        .frame(width: geometry.size.width / 2,
                               height: geometry.size.height / 5)
                        .background(Color.secondary.colorInvert())
                        .foregroundStyle(Color.primaryDefault)
                        .cornerRadius(20)
                        .opacity(self.isLoading ? 1 : 0)
                    }
                }
            } else {
                content
            }
        }
    }
}
