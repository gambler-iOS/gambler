//
//  Date+Extension.swift
//  gambler
//
//  Created by 박성훈 on 3/20/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation

extension Date {
    
    /// 지정한 시간 내에 포함되었는지 판별
    /// - Parameter minutes: 분
    /// - Returns: Bool: 포함되면 true / 포함이 안되면 false
    func isWithinPast(minutes: Int) -> Bool {
        let now = Date.now
        let timeAgo = Date.now.addingTimeInterval(-1 * TimeInterval(60 * minutes))  // 현재시간 - 지정된 시간
        let range = timeAgo...now
        return range.contains(self)
    }
}
