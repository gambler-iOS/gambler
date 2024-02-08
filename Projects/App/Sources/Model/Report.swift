//
//  Report.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Report: AvailableFirebase {
    var id: String
    let reviewId: String
    let userId: String
    let reportTitle: String
    let reportContent: String
    let reportCategory: String
}
