//
//  Color+Extension.swift
//  gambler
//
//  Created by cha_nyeong on 2/8/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

extension Color {
    static let gray50 = Color(hex: "F5F5F5")
    static let gray100 = Color(hex: "E9E9E9")
    static let gray200 = Color(hex: "D9D9D9")
    static let gray300 = Color(hex: "C4C4C4")
    static let gray400 = Color(hex: "9D9D9D")
    static let gray500 = Color(hex: "7B7B7B")
    static let gray600 = Color(hex: "555555")
    static let gray700 = Color(hex: "444444")
    static let gray800 = Color(hex: "262626")
    static let gray900 = Color(hex: "000000")
    // MARK: - 기본 색상 확정 시 변경 후 삭제
    static let primaryDefault = Color(hex: "FD5053")
    static let primaryPressed = Color(hex: "E22633")
    static let primaryDisabled = Color(hex: "F89B9C")
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
      
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
      
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
