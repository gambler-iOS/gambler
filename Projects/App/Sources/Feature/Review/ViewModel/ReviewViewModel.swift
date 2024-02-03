//
//  ReviewViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/1/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []

    private let firebaseManager = FirebaseManager.shared

    @MainActor
    func fetchData(byPostId id: String) async {
        reviews = await firebaseManager.fetchWhereData(collectionName: "Reviews", objectType: Review.self,
                                                       field: "postId", isEqualTo: id)
    }

    @MainActor
    func createReview(data: Review, withUpdateAggregate: AvailableAggregateReview) async {
        do {
            try firebaseManager.createData(collectionName: "Reviews", data: data)
            reviews.append(data)
        } catch {
            print("\(error)")
        }
    }
}
