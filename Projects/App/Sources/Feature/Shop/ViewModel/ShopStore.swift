//
//  ShopStore.swift
//  gambler
//
//  Created by daye on 2/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import SwiftUI

class ShopStore: ObservableObject {
    @Published var shops: [Shop] = []

    func getMyPlaceShopList(userPoint: Location) -> [Shop]{
        var myPlaceShopLists: [Shop] = []
        for shop in shops {
            if 1.2 > calculateDistanceBetweenPoints(point1: userPoint, point2: Location(latitude: shop.location.latitude, longitude: shop.location.longitude)) {
                myPlaceShopLists.append(shop)
            }
        }
        
        print(myPlaceShopLists)

        return myPlaceShopLists
    }
}
