//
//  ShopStore.swift
//  gambler
//
//  Created by daye on 2/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUI

final class ShopStore: ObservableObject {
    @Published var shopList: [Shop]
    @Published var userAreaShopList: [Shop]
    
    init() {
        shopList = Shop.dummyShopList
        userAreaShopList = []
    }
    
    func fetchUserAreaShopList(userPoint: GeoPoint) {
        let boundary: Double = 10
        userAreaShopList = []
        
        for shop in shopList 
        where boundary > calculateDistanceBetweenPoints(point1: userPoint,
                                                        point2: GeoPoint(latitude: shop.location.latitude, 
                                                                         longitude: shop.location.longitude)) {
            userAreaShopList.append(shop)
        }
    }
}

extension ShopStore {
    func calculateDistanceBetweenPoints(point1: GeoPoint, point2: GeoPoint) -> CLLocationDistance {
        let location1 = CLLocation(latitude: point1.latitude, longitude: point1.longitude)
        let location2 = CLLocation(latitude: point2.latitude, longitude: point2.longitude)
        
        return location1.distance(from: location2)/1000
    }
}
