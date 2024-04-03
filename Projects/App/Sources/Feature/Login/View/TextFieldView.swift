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
    @Binding var isShowingToast: Bool
    
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
                        isValid = text.isValidInput(minLength: minLength, maxLength: maxLength)
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
                        .foregroundStyle(!isDuplicated || !isValid ? Color.gray200 : Color.gray500)
                    
                        .padding(EdgeInsets(top: 18, leading: 8, bottom: 18, trailing: 8))  // 이거로는 높이가 좀 다름
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray200, lineWidth: 1.0))
                        .onTapGesture {
                            Task {
                                if isDuplicated && isValid {
                                    await duplicateCheck()
                                    print("중복여부: \(isDuplicated)")
                                    withAnimation(.easeIn(duration: 0.4)) {
                                        isShowingToast = true
                                    }
                                    
                                    isDisabled = isDuplicated ? true : false
                                }
                            }
                        }
                }
            }
            .padding(.bottom, 8)
            Text("영문, 한글, 숫자를 사용하여 \(minLength)~\(maxLength)자까지 가능합니다.")
                .font(.caption1M)
                .foregroundStyle(textColor)
        }
        .onAppear {
            self.isValid = text.isValidInput(minLength: minLength, maxLength: maxLength)
        }
    }
    
    /// 닉네임 중복검사
    /// - Returns: 중복 - true / 중복 없을 시 false
    private func duplicateCheck() async {
        do {
            let user: [User] = try await
            FirebaseManager.shared.fetchWhereIsEqualToData(collectionName: "Users", field: "nickname", isEqualTo: text)
            
            isDuplicated = user.isEmpty ? false : true
        } catch {
            print("Error fetching RegistrationView : \(error.localizedDescription)")
        }
    }
}

#Preview {
    TextFieldView(text: .constant("User"), isDisabled: .constant(true), isDuplicated: .constant(true), isShowingToast: .constant(false))
}
