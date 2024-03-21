//
//  Constants.swift
//  gambler
//
//  Created by cha_nyeong on 2/13/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

enum AppConstants {
    enum ChipSize {
        static let small: CGSize = CGSize(width: 8, height: 4)
        static let medium: CGSize = CGSize(width: 16, height: 8)
    }
    enum Padding {
        static let horizontal: CGFloat = 16
        static let vertical: CGFloat = 8
    }
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
    }
    enum ImageFrame {
        static let reviewListCell: CGSize = CGSize(width: 64, height: 64)
        static let miniGridItem: CGSize = CGSize(width: 100, height: 100)
        static let gridItem: CGSize = CGSize(width: 155, height: 155)
        static let listCell: CGSize = CGSize(width: 100, height: 100)
        static let cardItem: CGSize = CGSize(width: 240, height: 300)
    }
    
    enum MyPageFilter: Int, CaseIterable, Identifiable, FilterType {
        case shop
        case game
        
        var title: String {
            switch self {
            case .shop: return "매장"
            case .game: return "게임"
            }
        }
        
        var id: Int { return self.rawValue }
    }
    
    enum SearchFilter: Int, CaseIterable, Identifiable, FilterType {
        case genre
        case age
        case playerCount
        case playTime
        
        var title: String {
            switch self {
            case .genre: "장르"
            case .age: "연령"
            case .playerCount: "인원"
            case .playTime: "시간"
            }
        }
        
        var id: Int { return self.rawValue }
    }
    
    enum CollectionName {
        static let eventBanners: String = "EventBanners"
        static let games: String = "Games"
        static let shops: String = "Shops"
        static let reviews: String = "Reviews"
        static let users: String = "Users"
    }
    
    enum PostType {
        case shop
        case game
    }
}

extension AppConstants.MyPageFilter: Sequence {
    func makeIterator() -> IndexingIterator<[AppConstants.MyPageFilter]> {
        return IndexingIterator(_elements: AppConstants.MyPageFilter.allCases)
    }
}

extension AppConstants.SearchFilter: Sequence {
    func makeIterator() -> IndexingIterator<[AppConstants.SearchFilter]> {
        return IndexingIterator(_elements: AppConstants.SearchFilter.allCases)
    }
}

func getSafeAreaTop() -> CGFloat {
    guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first else {
        return 0
    }
    return keyWindow.safeAreaInsets.top
}
