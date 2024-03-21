//
//  MapViewModel.swift
//  gambler
//
//  Created by daye on 3/22/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation
import CoreLocation

final class MapViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    private let collectionName: String = AppConstants.CollectionName.shops
    
    @Published var fetchShopList: [Shop] = []
    @Published var fetchedShopList: [Shop] = []
    @Published var areaInShopList: [Shop] = []
    @Published var fetchedCountry: [String] = []
    
  
    @MainActor
    func fetchCountryData(country: String) async {
        fetchShopList.removeAll()
        guard !fetchedCountry.contains(country) else { return }
        do {
            print("fetchMapArea, 검색할 주소 : \(country)")
            fetchShopList = try await firebaseManager.fetchWhereIsEqualToData(collectionName: collectionName, 
                                                                              field: "shopCountry",
                                                                              isEqualTo: country)
            fetchedCountry.append(country)
            fetchedShopList += fetchShopList
            print("가져온 갯수: \(fetchShopList.count)")
            print("markPlace: \(fetchedCountry)")
        } catch {
            print("Error add MapViewModel : \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchUserAreaShopList(userPoint: GeoPoint) async {
        let boundary: Double = 10
        areaInShopList = []
        
        for shop in fetchedShopList
        where boundary >= calculateDistanceBetweenPoints(point1: userPoint,
                                                         point2: GeoPoint(latitude: shop.location.latitude,
                                                                          longitude: shop.location.longitude)) {
            areaInShopList.append(shop)
        }
    }
}

extension MapViewModel {
    func getCountry(mapPoint: GeoPoint) async -> String {
        let Geocoder = CLGeocoder()
        let location = CLLocation(
            latitude: mapPoint.latitude,
            longitude: mapPoint.longitude)
        let local: Locale = Locale(identifier: "Ko-kr")
        var country = ""
        
        do {
            let shopCountry = try await Geocoder.reverseGeocodeLocation(location, preferredLocale: local)
            guard let address = shopCountry.last,
                  let locality = address.locality,
                  let subLocality = address.subLocality,
                  let area = address.administrativeArea else { return "" }
            
            if area == "서울특별시" {
                country =  "\(area) \(subLocality)"
            } else if area == locality {
                country = "\(area)"
            } else {
                country = "\(area) \(locality)"
            }
        } catch {
            print("Error getCountry String : \(error.localizedDescription)")
        }
        return country
    }
    
    func calculateDistanceBetweenPoints(point1: GeoPoint, point2: GeoPoint) -> CLLocationDistance {
        let location1 = CLLocation(latitude: point1.latitude, longitude: point1.longitude)
        let location2 = CLLocation(latitude: point2.latitude, longitude: point2.longitude)
        
        return location1.distance(from: location2)/1000
    }
}
