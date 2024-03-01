//
//  DropMemuView.swift
//  gambler
//
//  Created by daye on 3/1/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct DropDownMemuView: View {
    @Binding var isShowingDropMenu: Bool
    @Binding var choiceCategory: ComplainCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            ForEach(ComplainCategory.allCases, id: \.self) { menu in
                menuCellView(menu: menu)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 56 * CGFloat(ComplainCategory.allCases.count))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
        }
    }
    
    private func menuCellView(menu: ComplainCategory) -> some View {
        Button(action: {
            isShowingDropMenu = false
            choiceCategory = menu
        }, label: {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 56)
                .foregroundColor(Color.white)
                .overlay {
                    HStack(spacing: .zero) {
                        Text(menu.complainName)
                            .padding(.horizontal, 16)
                            .font(.body1M)
                            .foregroundStyle(Color.gray700)
                        Spacer()
                    }
                }
        })
        .disabled(!isShowingDropMenu)
    }
}

#Preview {
    DropDownMemuView(isShowingDropMenu: .constant(true), choiceCategory: .constant(.spam))
}
