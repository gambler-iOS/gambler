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

    @MainActor
    func fetchOneData(byId id: String) async {
        shop = await firebaseManager.fetchOneData(collectionName: "Shops", objectType: Shop.self, byId: id)
    }

    @MainActor
    func updateReviewData(postData: AvailableAggregateReview, inputRate: Double) async {
        var calcRatingAvg = (Double(postData.reviewCount) * postData.reviewRatingAverage) + inputRate
        calcRatingAvg /= Double(postData.reviewCount + 1)
        let data: [String: Any] = ["reviewCount": postData.reviewCount + 1,
                                   "reviewRatingAverage": calcRatingAvg]

        do {
            try await firebaseManager.updateData(collectionName: "Shops", objectType: Shop.self,
                                                 byId: postData.id, data: data)
            shop = postData as? Shop
            shop?.reviewCount = data["reviewCount"] as? Int ?? 0
            shop?.reviewRatingAverage = data["reviewRatingAverage"] as? Double ?? 0
        } catch {
            print("ㅕ\(error)")
        }
    }
}
