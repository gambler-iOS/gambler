//
//  CustomerServiceView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct CustomerServiceView: View {
    var body: some View {
        VStack {
            Text("고객센터 뷰")
        }
        .modifier(BackButton())
    }
}

#Preview {
    CustomerServiceView()
}