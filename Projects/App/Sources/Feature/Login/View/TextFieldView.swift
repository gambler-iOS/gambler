//
//  TextFieldView.swift
//  gambler
//
//  Created by 박성훈 on 3/8/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct TextFieldView: View {
    @State private var isEditing: Bool = false
    @State private var isValid: Bool = false
    
    @Binding var text: String
    @Binding var isDisabled: Bool
    @Binding var isDuplicated: Bool
    @Binding var showToast: Bool
    
    var textColor: Color {
        isValid ? Color.gray300 : Color.primaryDefault
    }
    
    var textImage: Image {
        isValid && !isDuplicated ? Image("Success") : Image("searchClosed")
    }
    
    private let minLength: Int = 2
    private let maxLength: Int = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("닉네임")
                .font(.caption1M)
                .foregroundStyle(Color.gray700)
                .padding(.bottom, 8)
            
            HStack(spacing: 8) {
                HStack(spacing: .zero) {
                    TextField("닉네임을 입력해주세요", text: $text, onEditingChanged: { _ in
                        withAnimation(.interpolatingSpring, {
                            self.isEditing.toggle()
                        })
                    })
                    .foregroundColor(.gray700)
                    .keyboardType(.webSearch)
                    .autocorrectionDisabled()
                    .onChange(of: self.text) { _, newValue in
                        if newValue.count > maxLength {  // 20자가 안넘도록 막음
                            self.text = String(newValue.prefix(maxLength))
                        }
                        isValid = isValidInput(input: text)
                        isDuplicated = true
                        isDisabled = true
                    }
                    if !text.isEmpty {
                        textImage
                            .resizable()
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                text = ""
                            }
                    }
                }
                .padding(16)
                .background(Color.gray50)
                .cornerRadius(8)
                
                if !text.isEmpty {
                    Text("중복확인")
                        .font(.body1B)
                        .foregroundStyle(!isDuplicated ? Color.gray200 : Color.gray500)
                    
                        .padding(EdgeInsets(top: 18, leading: 8, bottom: 18, trailing: 8))  // 이거로는 높이가 좀 다름
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray200, lineWidth: 1.0))
                        .onTapGesture {
                            Task {
                                if isDuplicated {  // 중복일 떈 중복체크
                                    await duplicateCheck()
                                    print("중복여부: \(isDuplicated)")
                                    showToast = true
                                    
                                    if isValid && !isDuplicated { // 가능한 문자 & 중복x
                                        isDisabled = false
                                    } else {
                                        isDisabled = true
                                    }
                                }
                            }
                        }
                }
            }
            Text("영문, 한글, 숫자를 사용하여 \(minLength)~\(maxLength)자까지 가능합니다.")
                .font(.caption1M)
                .foregroundStyle(textColor)
        }
        .onAppear {
            self.isValid = isValidInput(input: text)
        }
    }
    
    /// 입력이 한글, 영어, 숫자로로 2~20글자로 이루어져 있는지를 판별하는 함수
    /// - Parameter input: 텍스트 필드의 텍스트
    /// - Returns: 부합하면 true 아니면 false
    private func isValidInput(input: String) -> Bool {
        let pattern = "^[가-힣a-zA-Z0-9]+$"  // 정규식 패턴(한글/영어/숫자)
        
        if input.count >= minLength && input.count <= maxLength {
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)  // 대소문자 구분하지 않고 탐색
                let nsInput = input as NSString
                let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: nsInput.length))
                
                return !matches.isEmpty  // matches.count > 0
            } catch {
                print("Regex Error: \(error.localizedDescription)")
                return false
            }
        } else {
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
    TextFieldView(text: .constant("User"), isDisabled: .constant(true), isDuplicated: .constant(true), showToast: .constant(false))
}
