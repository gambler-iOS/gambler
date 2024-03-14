//
//  TextFieldView.swift
//  gambler
//
//  Created by 박성훈 on 3/8/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    @Binding var isDuplicated: Bool
    @State private var isEditing: Bool = false
    @State private var textColor: Color = Color.gray300
    
    private let maxLength: Int = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("닉네임")
                .font(.caption1M)
                .foregroundStyle(Color.gray700)
                .padding(.bottom, 8)
            
            GeometryReader { proxy in
                HStack(spacing: 8) { 
                    HStack {
                        TextField("닉네임을 입력해주세요", text: $text, onEditingChanged: { _ in
                            withAnimation(.interpolatingSpring, {
                                self.isEditing.toggle()
                            })
                        })
                        .foregroundColor(.gray700)
                        .keyboardType(.webSearch)
                        .autocorrectionDisabled()
                        .onChange(of: self.text) { _, newValue in
                            textColor = isValidInput(input: newValue) ? Color.gray300 : Color.primaryDefault
                        }
                        .onChange(of: self.text) { _, newValue in
                            if newValue.count > maxLength {
                                self.text = String(newValue.prefix(maxLength))
                            }
                        }
                        
                        if !text.isEmpty {
                            Button {
                                text = ""
                            } label: {
                                Image(isDuplicated ? "searchClosed" :
                                        "Success")
                                .resizable()
                                .frame(width: 24, height: 24)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.gray50)
                    .cornerRadius(8)
                    
                    if !text.isEmpty {
                        Button {
                            Task {
                                await duplicateCheck()
                                
//                                if !isDuplicated && text.count >= 2 {
//                                    isDisabled = false
//                                } else {
//                                    isDisabled = true
//                                }
                            }
                        } label: {
                            Text("중복확인")
                                .font(.body1B)
                                .foregroundStyle(Color.gray500) // 500
                                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
//                        .frame(height: proxy.size.height)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray200, lineWidth: 1.0))
                    }
                    
                }
            }
            Text("영문, 한글, 숫자를 사용하여 20자까지 가능합니다.")
                .font(.caption1M)
                .foregroundStyle(textColor)  // 조건에 따라 PrimaryDefault
        }
    }
    
    /// 입력이 한글, 영어, 숫자로만 이루어져 있는지를 판별하는 함수
    /// - Parameter input: 텍스트 필드의 텍스트
    /// - Returns: Bool
    private func isValidInput(input: String) -> Bool {
        let pattern = "^[가-힣a-zA-Z0-9]+$"  // 정규식 패턴(한글/영어/숫자)
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)  // 대소문자 구분하지 않고 탐색
            let nsInput = input as NSString
            let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: nsInput.length))
            
            return !matches.isEmpty  // matches.count > 0
        } catch {
            print("Regex Error: \(error.localizedDescription)")
            return false
        }
    }
    
    /// 닉네임 중복검사
    /// - Returns: 중복 - true / 중복 없을 시 false
    private func duplicateCheck() async {
        let user = await FirebaseManager.shared.fetchWhereData(collectionName: "Users", objectType: User.self, field: "nickname", isEqualTo: text)
        
        isDuplicated = user.isEmpty ? false : true
    }
}

#Preview {
    TextFieldView(text: .constant(""), isDuplicated: .constant(false))
}
