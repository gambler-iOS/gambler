//
//  Complain.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Complain: AvailableFirebase {
    var id: String
    let complainTitle: String
    let complainContent: String
    let complainImage: [String]?
    let createdDate: Date
}
