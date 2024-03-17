//
//  ResignModalView.swift
//  gambler
//
//  Created by daye on 3/13/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct CustomModalView: View {
    @Binding var isShowingModal: Bool
    let title: String
    let content: String
    let modalAction: (() -> Void)
    
    var body: some View {
        VStack {
            modalCellView
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color.white)
                        .frame(height: 221)
                }
                .padding(24)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .background(ClearBackground())
    }
    
    private var modalCellView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subHead2B)
            Text(content)
                .font(.body2M)
                .foregroundStyle(Color.gray500)
            HStack(spacing: 8) {
                ProfileButtonView(text: "취소", width: 127.5, height: 56, isDefaultButton: true, isDisabled: false)
                    .onTapGesture {
                        isShowingModal = false
                    }
                ProfileButtonView(text: "확인", width: 127.5, height: 56, isDefaultButton: false, isDisabled: false)
                    .onTapGesture {
                        modalAction()
                    }
            }
            .padding(.top, 16)
        }.padding(24)
            .padding(.top, 16)
    }
}

#Preview {
    CustomModalView(isShowingModal: .constant(true), title: "제목", content: "설명"){
        print("결과")
    }
}
