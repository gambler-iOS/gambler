//
//  ReviewViewModel.swift
//  gambler
//
//  Created by 박성훈 on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

final class ReviewViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    private let collectionName: String = AppConstants.CollectionName.reviews
    
    @Published var reviews: [Review] = []
    
    @Published var dummyReviews: [Review] = []
    @Published var dummyShops: [Shop] = []
    
    init() {
        generateDummyData()
    }
    
    @MainActor
    func addData(review: Review) async {
        do {
            try firebaseManager.createData(collectionName: collectionName, data: review)
        } catch {
            print("Error add \(collectionName) : \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchData() async {
        var tempReviews: [Review] = []
        reviews.removeAll()
        do {
            tempReviews = try await firebaseManager.fetchAllData(collectionName: collectionName)
        } catch {
            print("Error fetching \(collectionName) : \(error.localizedDescription)")
        }
        self.reviews = tempReviews
    }
    
    private func generateDummyData() {
        for _ in 1...7 {
            dummyReviews.append(Review(id: UUID().uuidString,
                                       postId: UUID().uuidString,
                                       userId: UUID().uuidString,
                                       reviewContent: "친구 3명이랑 했는데 일반 마피아보다 색달라서 재밌었어요. 쉬운 게임이여서 진입장벽 없이 바로 할 수 있음요 ~!",
                                       reviewRating: 4.0,
                                       reviewImage: ["https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186"],
                                       createdDate: Date(),
                                       category:  .game
                                      ))
            
            dummyShops.append(Shop(
                id: UUID().uuidString,
                shopName: "레드버튼 강남점",
                shopAddress: "address",
                shopImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
                location: GeoPoint(latitude: 120.1, longitude: 140),
                shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                openingHour: ["10시"],
                amenity: ["주차"],
                shopDetailImage: ["detailImage"],
                createdDate: Date(),
                reviewCount: 3,
                reviewRatingAverage: 3.5,
                ShopCountry: "서울특별시"))
        }
    }
}
