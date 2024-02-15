//
//  String+Extension.swift
//  gambler
//
//  Created by 박성훈 on 2/15/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

extension Date {
  // MARK: - 기본 & 짧은 날짜 표시
  public var basic: String {
    return toString("yyyy년 M월 d일")
  }
  public var summary: String {
    return toString("yyyy.MM.dd")
  }
  
  // MARK: - Date -> String
  public func toString(_ dateFormat: String) -> String {
    return DateFormatter
      .convertToKoKR(dateFormat: dateFormat)
      .string(from: self)
  }
}

extension DateFormatter {
  public static func convertToKoKR(dateFormat: String) -> DateFormatter {
    let dateFormatter = createKoKRFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
  }
}

private func createKoKRFormatter() -> DateFormatter {
  let dateFormatter = DateFormatter()
  dateFormatter.locale = Locale(identifier: "ko_KR")
  dateFormatter.timeZone = TimeZone(abbreviation: "KST")
  return dateFormatter
}
