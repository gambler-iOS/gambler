//
//  TextEditorView.swift
//  gambler
//
//  Created by 박성훈 on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct TextEditorView: View {
    @State private var placeholder: String = "리뷰를 남겨주세요."
    @Binding var reviewContent: String
    let limitChar: Int = 150
    // 포커스필드를 위한 열거형
    enum Field: Hashable {
        case reasonForReporting
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            // placeholder 구현
            if reviewContent.isEmpty {
                Text(placeholder)   // State 변수 선언
                    .lineSpacing(10)
                    .font(.body2M)
                    .foregroundColor(Color.gray300)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                    .zIndex(1)  // 우선순위
                    .onTapGesture {
                        self.focusedField = .reasonForReporting
                    }
            }
            
            // 텍스트 에디터
            VStack {
                TextEditor(text: $reviewContent)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray300, lineWidth: 1.0))
                    .keyboardType(.default)
                    .foregroundColor(Color.black)
                    .focused($focusedField, equals: .reasonForReporting)
                // 글자 수 제한
                    .onChange(of: self.reviewContent, perform: {
                        if $0.count > limitChar {
                            self.reviewContent = String($0.prefix(limitChar))
                        }
                    })
                // 텍스트에디터를 다시 누르면 키보드 내려가게 함
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            }
            .frame(height: 200)
        }  // ZStack
    }
}

#Preview {
    TextEditorView(reviewContent: .constant(""))
}
