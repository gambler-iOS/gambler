//
//  DetailViewSegment.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//
import Foundation

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
    
