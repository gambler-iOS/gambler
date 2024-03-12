//
//  ResignModalView.swift
//  gambler
//
//  Created by daye on 3/13/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

struct ResignModalView: View {
    @Binding var isShowingResingModal: Bool
    
    var body: some View {
        VStack {
            resignModalCellView
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color.white)
                        .frame(height: 221)
                }
                .padding(24)
            
        }
        
        
    }
    
    private var resignModalCellView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("정말 탈퇴하시겠어요?")
                .font(.subHead2B)
            Text("탈퇴 후에는 작성하신 리뷰를 수정 혹은 삭제할 수 없어요. 탈퇴 신청 전에 꼭 확인해주세요.")
                .font(.body2M)
            HStack(spacing: 8) {
                ProfileButtonView(text: "취소", width: 127.5, height: 56, isDefaultButton: true)
                ProfileButtonView(text: "확인", width: 127.5, height: 56, isDefaultButton: false)
                    .onTapGesture {
                        isShowingResingModal = false
                    }
            }
            .padding(.top, 24)
        }.padding(24)
    }
    
    private func resignModalButtonView(title: String, isMainColor: Bool) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .overlay {
                Text(title)
                    .font(.body1B)
            }
    
    }
}

#Preview {
    ResignModalView(isShowingResingModal: .constant(true))
}
