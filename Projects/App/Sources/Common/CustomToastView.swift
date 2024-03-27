//
//  CustomToastView.swift
//  gambler
//
//  Created by daye on 3/15/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI

enum ToastCategory {
    case signUp
    case deleteAccount
    case complain
}

struct CustomToastView: View {
    var content: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 99)
            .frame(height: 45)
            .foregroundStyle(Color.gray500)
            .overlay {
                Text(content)
                    .font(.body2M)
                    .foregroundStyle(Color.white)
            }
    }
}

#Preview {
    CustomToastView(content: "리뷰 작성이 완료되었습니다!")
}
