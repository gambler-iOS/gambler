//
//  RoundedCorner.swift
//  gambler
//
//  Created by daye on 2/2/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundSpecificCorners: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width, height: 40)
            .roundedCorner(20, corners: [.topLeft, .topRight])
    }
}
