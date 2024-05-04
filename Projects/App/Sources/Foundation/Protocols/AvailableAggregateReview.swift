//
//  AvailableAggregateReview.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/1/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

protocol AvailableAggregateReview {
    var id: String { get }
    var reviewCount: Int { get }
    var reviewRatingAverage: Double { get }
}
