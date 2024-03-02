//
//  ShopListViewModel.swift
//  gambler
//
//  Created by cha_nyeong on 2/28/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class ShopListViewModel: ObservableObject {
    @Published var shops: [Shop] = []
    @Published var showGrid: Bool = false
    
    init() {
        generateDummyData()
    }

    func generateDummyData() {
        shops.append(Shop.dummyShop)
        shops.append(Shop.dummyShop)
        shops.append(Shop.dummyShop)
        shops.append(Shop.dummyShop)
    }
}
