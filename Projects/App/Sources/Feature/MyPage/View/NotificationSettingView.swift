//
//  NotificationSettingView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct NotificationSettingView: View {
    var body: some View {
        VStack {
            Text("알림 설정 뷰")
        }
        .modifier(BackButton())
    }
}

#Preview {
    NotificationSettingView()
}
