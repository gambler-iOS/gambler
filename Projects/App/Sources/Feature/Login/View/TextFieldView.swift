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
    @State private var isEditing = false
    
    /*  1. 영어 / 한글 / 숫자만 입력받음
        2. 최대 20글자만 받도록
        3. 닉네임 중복 확인
    */
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("닉네임")
                .font(.caption1M)
                .foregroundStyle(Color.gray700)
                .padding(.bottom, 8)
            
            HStack {
                TextField("닉네임을 입력해주세요", text: $text, onEditingChanged: { _ in
                    withAnimation(.interpolatingSpring, {
                        self.isEditing.toggle()
                    })
                })
                .foregroundColor(.gray700)
                .keyboardType(.webSearch)
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image("searchClosed")  // 중복 아니면 Image("Success")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(16)
            .background(Color.gray50)
            .cornerRadius(8)
            
            Text("영문, 한글, 숫자를 사용하여 20자까지 가능합니다.")
                .font(.caption1M)
                .foregroundStyle(Color.gray300)  // 조건에 따라 PrimaryDefault
        }
    }
}

#Preview {
    TextFieldView(text: .constant(""))
}
