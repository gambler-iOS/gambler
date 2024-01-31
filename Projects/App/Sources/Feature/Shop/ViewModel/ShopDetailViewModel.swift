//
//  ShopDetailViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/31/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

class ShopDetailViewModel: ObservableObject {
    @Published var shop: Shop?

    private let firebaseManager = FirebaseManager.shared

    func fetchData(byId id: String) async {
        shop = await firebaseManager.fetchOneData(collectionName: "Shops", objectType: Shop.self, byId: id)
    }
}
