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
            Toggle("푸시 알림 받기", isOn: $push)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
            BorderView()
                .padding(.vertical, 24)
            Toggle("공지사항/새소식", isOn: $notice)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
            Divider()
            Toggle("새 댓글", isOn: $reply)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
            Divider()
            Toggle("추천 글/정보", isOn: $info)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
            Divider()
            Spacer()
        }
        .padding(.top, 24)
        .toggleStyle(SwitchToggleStyle(tint: Color.primaryDefault))
        .font(.body1B)
        .navigationTitle("알림 설정")
        .modifier(BackButton())
    }
}

#Preview {
    NotificationSettingView()
}
