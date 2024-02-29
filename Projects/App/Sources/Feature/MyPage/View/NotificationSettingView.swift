//
//  NotificationSettingView.swift
//  gambler
//
//  Created by daye on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct NotificationSettingView: View {
    @State private var push: Bool = false
    @State private var notice: Bool = false
    @State private var reply: Bool = false
    @State private var info: Bool = false
    
    var body: some View {
        VStack {
            toggleCellView(title: "푸시 알림 받기", toggleState: $push)
            BorderView()
                .padding(.vertical, 24)
            toggleCellView(title: "공지사항/새소식", toggleState: $notice)
            Divider()
            toggleCellView(title: "새 댓글", toggleState: $reply)
            Divider()
            toggleCellView(title: "추천 글/정보", toggleState: $info)
            Divider()
            Spacer()
        }
        .padding(.top, 24)
        .navigationTitle("알림 설정")
        .modifier(BackButton())
    }
    
    private func toggleCellView(title: String, toggleState: Binding<Bool>) -> some View {
        Toggle(title, isOn: toggleState)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .toggleStyle(SwitchToggleStyle(tint: Color.primaryDefault))
            .font(.body1B)
    }
}

#Preview {
    NotificationSettingView()
}
