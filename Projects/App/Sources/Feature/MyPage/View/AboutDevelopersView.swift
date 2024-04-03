//
//  AboutDevelopersView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

#warning("만약 웹뷰로 진행하면 해당 뷰는 없애도 될 것 같습니다.")
struct AboutDevelopersView: View {
    var body: some View {
        VStack {
            Text("개발자 정보 뷰")
        }
        .modifier(BackButton())
    }
}

#Preview {
    AboutDevelopersView()
}
