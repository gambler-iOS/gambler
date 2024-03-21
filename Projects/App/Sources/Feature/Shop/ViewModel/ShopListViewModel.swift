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
    
    private let firebaseManager = FirebaseManager.shared
    private let collectionName = AppConstants.CollectionName.shops
    
    
    init(){
        
    }
    
    func generateDummyData() {
        shops.append(Shop.dummyShop)
        shops.append(Shop.dummyShop)
        shops.append(Shop.dummyShop)
        shops.append(Shop.dummyShop)
    }
    
    @MainActor
    func fetchData(type: ListTypeEnum) async {
        var tempShops: [Shop] = []
        shops.removeAll()
        do {
            switch type {
            case .normal:
                tempShops = try await firebaseManager.fetchOrderData(collectionName: collectionName, orderBy: "createdDate", limit: 10)
            case .popular:
                tempShops = try await firebaseManager.fetchOrderData(collectionName: collectionName,orderBy: "reviewCount", limit: 5)
//                tempShops = try await firebaseManager.fetchAllData(collectionName: collectionName)
//                print(tempShops.count)
            case .newly:
                tempShops = try await firebaseManager.fetchOrderData(collectionName: collectionName,orderBy: "createdDate", limit: 5)
            }
        } catch {
            print("Error fetching \(collectionName) : \(error.localizedDescription)")
        }
        self.shops = tempShops
    }
    
}

enum ListTypeEnum: String {
    case normal = ""
    case popular = "인기 매장"
    case newly = "신규 매장"
}
