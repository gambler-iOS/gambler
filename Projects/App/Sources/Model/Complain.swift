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
    let complainCategory: ComplainCategory
    let complainContent: String
    let complainImage: [String]?
    let createdDate: Date
}

enum ComplainCategory: CaseIterable, Codable {
    case spam
    case paidAds
    case falseInformation
    case harassmentOrPrivacyViolations
    case adultContent
    case otehr
    
    var complainName: String {
        switch self {
        case .spam:
            return "스팸"
        case .paidAds:
            return "유료 광고 포함"
        case .falseInformation:
            return "거짓 정보"
        case .harassmentOrPrivacyViolations:
            return "괴롭힘 또는 개인정보 침해"
        case .adultContent:
            return "성인용 컨텐츠"
        case .otehr:
            return "기타"
        }
    }
}

