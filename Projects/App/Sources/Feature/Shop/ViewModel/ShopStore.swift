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
    private let firebaseManager = FirebaseManager.shared
    private let collectionName: String = AppConstants.CollectionName.shops
    @Published var markPlace: [String] = []
    
    init() {
        shopList = []
        userAreaShopList = []
    }
    
    @MainActor
    func fetchAllMap() async {
        shopList.removeAll()
        
        do {
            shopList = try await firebaseManager.fetchAllData(collectionName: collectionName)
        } catch {
            print("Error add ShopStore : \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func getCountry(mapPoint: GeoPoint) async -> String {
        let Geocoder = CLGeocoder()
        let location = CLLocation(
            latitude: mapPoint.latitude,
            longitude: mapPoint.longitude)
        let local: Locale = Locale(identifier: "Ko-kr")
        var addressString = ""
        
        do {
            let shopCountry = try await Geocoder.reverseGeocodeLocation(location, preferredLocale: local)
            guard let address = shopCountry.last,
                  let locality = address.locality,
                  let subLocality = address.subLocality,
                  let area = address.administrativeArea else { return "" }
            
            if area == "서울특별시" {
                addressString =  "\(area) \(subLocality)"
            } else if area == locality {
                addressString = "\(area)"
            } else {
                addressString = "\(area) \(locality)"
            }
        } catch {
            print("Error getCountry String : \(error.localizedDescription)")
        }
        return addressString
    }
    
    
    @MainActor
    func fetchMapArea(countryString: String) async {
        shopList.removeAll()
        do {
            print("fetchMapArea, 검색할 주소 : \(countryString)")
            shopList = try await firebaseManager.fetchWhereIsEqualToData(collectionName: collectionName, field: "shopCountry", isEqualTo: countryString)
            print("가져온 갯수: \(shopList.count)")
            print("markPlace: \(markPlace)")
        } catch {
            print("Error add MapViewModel : \(error.localizedDescription)")
        }
    }
   
    /*
    func calcCountry() {
     /*if administrativeArea == 서을일때는
     추가) if admini~ 가 서울특별시 이면
     locality 대신 subLocality로 조회*/
     
        let location = CLLocation(
            latitude: Double((json["y"] as? String)!) ?? Shop.dummyShop.location.latitude,
            longitude: Double((json["x"] as? String)!) ?? Shop.dummyShop.location.longitude)
        
        let local: Locale = Locale(identifier: "Ko-kr")
        let shopCountry = try await Geocoder.reverseGeocodeLocation(location, preferredLocale: local)
        guard let address = shopCountry.last,
              let locality = address.locality,
              let area = address.administrativeArea else { return nil }
        
        var countryString = ""
        
        if area == locality {
            countryString = "\(area)"
        } else {
            countryString = "\(area) \(locality)"
        }
    }*/
   
    func fetchUserAreaShopList(userPoint: GeoPoint) {
        let boundary: Double = 10
        userAreaShopList = []
        
        for shop in shopList 
        where boundary >= calculateDistanceBetweenPoints(point1: userPoint,
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
