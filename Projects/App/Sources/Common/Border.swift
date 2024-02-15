//
//  BoldDivider.swift
//  gambler
//
//  Created by daye on 2/7/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct Border: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(Color.gray50)
            .frame(height: 4)
    }
}

#Preview {
    Border()
}
