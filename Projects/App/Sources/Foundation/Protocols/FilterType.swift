//
//  FilterType.swift
//  gambler
//
//  Created by cha_nyeong on 2/14/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

// 필터 타입의 처리 하기 위한 프로토콜
protocol FilterType: CaseIterable {
    var title: String { get }
}
