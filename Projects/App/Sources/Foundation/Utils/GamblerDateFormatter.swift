//
//  GamblerDateFormatter.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class GamblerDateFormatter {
    static let shared = GamblerDateFormatter()
    
    private init() { }
    
    private var periodFieldFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }
    
    private var calendarDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }
    
    func periodDateString(from date: Date) -> String {
        periodFieldFormatter.string(from: date)
    }
    
    func calendarDateString(from date: Date) -> String {
        calendarDateFormatter.string(from: date)
    }
}
