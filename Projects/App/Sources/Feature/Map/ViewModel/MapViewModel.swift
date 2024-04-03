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
    
    @Published var fetchNewShopList: [Shop] = []
    @Published var fetchedShopList: [Shop] = []
    @Published var fetchedCountry: [String] = []
    @Published var areaInShopList: [Shop] = []
     
    @MainActor
    func fetchCountryData(country: String) async {
        fetchNewShopList.removeAll()
        
        guard !fetchedCountry.contains(country) else { return }
        do {
            print("fetchMapArea, 검색할 주소 : \(country)")
            fetchNewShopList = try await firebaseManager.fetchWhereIsEqualToData(collectionName: collectionName, 
                                                                              field: "shopCountry",
                                                                              isEqualTo: country)
            fetchedCountry.append(country)
            fetchedShopList += fetchNewShopList
            print("가져온 갯수: \(fetchNewShopList.count)")
            print("업데이트 된 지역 이름: \(fetchedCountry)")
        } catch {
            print("Error fetchCountryData : \(error.localizedDescription)")
        }
    }
    
    func fetchOneShop(country: String) async -> Shop? {
        var tempShop: Shop?
        do {
            if let data: Shop = try await firebaseManager.fetchWhereOneData(collectionName: collectionName, field: "shopCountry", byData: country)   {
                tempShop = data
            }
        } catch {
            print("Error fetching GameInfo GameDetailViewModel : \(error.localizedDescription)")
        }
        return tempShop
    }
    
    @MainActor
    func filterShopsByCountry(country: String) async {
        areaInShopList.removeAll()
        areaInShopList = fetchedShopList.filter { $0.shopCountry == country }
    }
    
    @MainActor
    func fetchUserAreaShopList(userPoint: GeoPoint) async {
        let boundary: Double = 10
        areaInShopList.removeAll()
        
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
