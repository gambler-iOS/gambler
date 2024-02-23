//
//  SearchKeyword.swift
//  gambler
//
//  Created by cha_nyeong on 2/20/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class SearchKeyword {
    var timestamp: Date
    var keyword: String
    
    init(timestamp: Date, keyword: String) {
        self.timestamp = timestamp
        self.keyword = keyword
    }
}
