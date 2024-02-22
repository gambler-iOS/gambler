//
//  ProfileEditView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ProfileEditView: View {
    var body: some View {
        VStack {
            Text("프로필 수정 뷰")
        }
        .modifier(BackButton())
    }
}

#Preview {
    ProfileEditView()
}
