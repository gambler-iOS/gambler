//
//  TextEditorView.swift
//  gambler
//
//  Created by 박성훈 on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct TextEditorView: View {
    @FocusState var isInputActive: Bool
    
    @Binding var text: String
    let placeholder: String
    let maxLength: Int = 500
    let height: CGFloat = 200
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: .zero) {
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.body2M)
                            .foregroundColor(Color.gray300)
                            .padding(16)
                            .zIndex(1)
                            .onTapGesture {
                                isInputActive ? (isInputActive = false) : (isInputActive = true)
                            }
                    }
                    
                    TextEditor(text: $text)
                        .font(.body2M)
                        .foregroundColor(Color.gray700)
                        .lineSpacing(8)
                        .frame(height: (proxy.size.height - 48) * 0.9)
                        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                HStack {
                                    EmptyView()
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Button {
                                        isInputActive = false
                                    } label: {
                                        Text("완료")
                                            .foregroundStyle(Color.gray700)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        .disableAutocorrection(true)
                        .focused($isInputActive)
                }
                // 글자 수 제한
                HStack {
                    Spacer()
                    Text("\(text.count) / \(maxLength)")
                        .font(.caption2M)
                        .foregroundStyle(text.count  >= maxLength ? Color.primaryDefault : Color.gray300)
                }
                .frame(height: (proxy.size.height - 48) * 0.1)
                .padding(16)
            }
            .onAppear(perform: UIApplication.shared.hideKeyboard)
        }
        .frame(height: height)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray300, lineWidth: 1.0))
        .onChange(of: self.text) { _, newValue in
            if newValue.count > maxLength {
                self.text = String(newValue.prefix(maxLength))
            }
        }
    }
}

#Preview {
    TextEditorView(text: .constant(""), placeholder: "리뷰를 남겨주세요.")
}
