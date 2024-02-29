//
//  ProfileEditView.swift
//  gambler
//
//  Created by daye on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct CustomerServiceView: View {
    @State private var serviceContent: String = ""
    @State private var disabledButton: Bool = true
    @State private var selectedOption = 0
    @State private var tap = false
    let options = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            titleView
                .padding(.top, 24)
                .padding(.bottom, 16)
            TitleAndBoxView(title: "항목")
                .padding(.vertical, 16)
            TextEditorView(text: $serviceContent, placeholder: "내용을 적어주세요")
                .padding(.vertical, 16)
            AddImageView(topPadding: .constant(0))
            Spacer()
            CTAButton(disabled: $disabledButton, title: "완료") {
                print("완료 버튼 눌림")
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .navigationTitle("고객 센터")
        .modifier(BackButton())
    }
    
    private var titleView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("무슨 일인가요?")
                .font(.head2B)
            Text("확인 후 이메일로 회신 드리고 있습니다!")
                .font(.caption1M)
                .foregroundStyle(Color.gray300)
                .padding(.top, 10)
        }
    }
    
    
}

#Preview {
    CustomerServiceView()
}
