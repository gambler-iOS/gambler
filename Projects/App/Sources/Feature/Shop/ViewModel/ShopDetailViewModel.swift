//
//  ShopDetailViewModel.swift
//  gambler
//
//  Created by cha_nyeong on 4/3/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation

final class ShopDetailViewModel: ObservableObject {
    @Published var shop: Shop = Shop.dummyShop
    @Published var reviews: [Review] = []
    
    private let firebaseManager = FirebaseManager.shared
    
    init() { }
    
    // 매장 데이터 가져오기
    @MainActor
    func fetchShopInfo() async {
        do {
            if let data: Shop = try await firebaseManager
                .fetchOneData(collectionName: AppConstants.CollectionName.shops, byId: shop.id) {
                shop = data
            }
        } catch {
            print("\(#function): \(error.localizedDescription)")
        }
    }
    
    // 리뷰 데이터 가져오기
    @MainActor
    func fetchReviewData() async {
        do {
            reviews = try await firebaseManager
                .fetchWhereIsEqualToData(collectionName: AppConstants.CollectionName.reviews,
                                         field: "postId",
                                         isEqualTo: shop.id,
                                         orderBy: "createdDate",
                                         limit: 3)
        } catch {
            print("\(#function) : \(error.localizedDescription)")
        }
    }
}
