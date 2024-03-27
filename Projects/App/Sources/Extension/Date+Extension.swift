//
//  Date+Extension.swift
//  gambler
//
//  Created by 박성훈 on 3/20/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation

extension Date {
    func isWithinPast(minutes: Int) -> Bool {
        let now = Date.now
        let timeAgo = Date.now.addingTimeInterval(-1 * TimeInterval(60 * minutes))
        let range = timeAgo...now
        return range.contains(self)
    }
}
