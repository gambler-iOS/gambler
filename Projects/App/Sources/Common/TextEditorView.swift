//
//  TextEditorView.swift
//  gambler
//
//  Created by 박성훈 on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct TextEditorView: View {
    @FocusState private var focusedField: Field?
    @Binding var reviewContent: String
    let placeholder: String
    let limitChar: Int = 200
    let height: CGFloat = 200
    
    // 포커스필드를 위한 열거형
    enum Field: Hashable {
        case reasonForReporting
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $reviewContent)
                .foregroundColor(Color.gray700)
                .lineSpacing(10)
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray300, lineWidth: 1.0))
                .focused($focusedField, equals: .reasonForReporting)
                .onChange(of: self.reviewContent) { _, newValue in
                    if newValue.count > limitChar {
                        self.reviewContent = String(newValue.prefix(limitChar))
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
            if reviewContent.isEmpty {
                Text(placeholder)
                    .lineSpacing(10)
                    .foregroundColor(Color.gray300)
                    .padding(16)
                    .zIndex(1)
                    .onTapGesture {
                        self.focusedField = .reasonForReporting
                    }
            }
        }
        .frame(height: height)
        .font(.body2M)
        
    }
}

#Preview {
    TextEditorView(reviewContent: .constant(""), placeholder: "리뷰를 남겨주세요.")
}
