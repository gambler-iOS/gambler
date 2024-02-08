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
    let noticeContent: String
    let noticeImage: [String]?
    let noticeLink: String
    let createdDate: Date
}
