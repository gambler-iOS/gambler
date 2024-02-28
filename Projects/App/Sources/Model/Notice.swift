//
//  Notice.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Notice: AvailableFirebase {
    var id: String
    let noticeTitle: String
    let noticeLink: String
    let createdDate: Date
    
    static let dummyNotice = Notice(
        id: UUID().uuidString,
        noticeTitle: "앱 1.0.1 업데이트 안내",
        noticeLink: "ㅇㅅㅇ",
        createdDate: Date()
    )
}
