//
//  ReportDetailView.swift
//  gambler
//
//  Created by 박성훈 on 2/13/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ReportContentView: View {
    
    enum Field: Hashable {
            case reasonForReporting
    }
        
    @FocusState private var focusedField: Field?
    @State private var reportContent: String = ""
    @State private var placeholder: String = "앱의 버그 및 신고사항을 자유롭게 적어주세요"
    private let limitChar: Int = 100
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // placeholder 구현
                if reportContent.isEmpty {
                    Text(placeholder)   // State 변수 선언
                        .lineSpacing(10)
                        .foregroundColor(Color.primary.opacity(0.25))
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .zIndex(1)  // 우선순위
                        .onTapGesture {
                            self.focusedField = .reasonForReporting
                        }
                }
                
                // 텍스트 에디터
                VStack {
                    TextEditor(text: $reportContent)
                        .keyboardType(.default)
                        .foregroundColor(Color.black)
                        .frame(height: 150)
                        .lineSpacing(10)
                        .focused($focusedField, equals: .reasonForReporting)
                    
                    // 글자 수 제한
                        .onChange(of: self.reportContent, perform: {
                            if $0.count > limitChar {
                                self.reportContent = String($0.prefix(limitChar))
                            }
                        })
                    // 텍스트에디터를 다시 누르면 키보드 내려가게 함
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    
                    VStack(alignment: .trailing) {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("\(reportContent.count) / \(limitChar)")
                        }
                    }
                    .padding()  // Text를 떨어뜨리기 위함
                }
                .border(.secondary)
            }  // ZStack
        }
    }
}

#Preview {
    ReportContentView()
}
