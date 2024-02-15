//
//  DetailViewSegment.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//
import Foundation

enum DetailViewSegment: Int, CaseIterable, Identifiable {
    case shop = 0
    case game = 1
    
    var id: Int { return self.rawValue }
}
