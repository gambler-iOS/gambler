//
//  BackButton.swift
//  gambler
//
//  Created by 박성훈 on 2/22/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct BackButton: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image("arrowLeft")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
    }
}
