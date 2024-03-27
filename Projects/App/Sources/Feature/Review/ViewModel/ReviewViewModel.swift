//
//  ReviewViewModel.swift
//  gambler
//
//  Created by 박성훈 on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

final class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []

    private let firebaseManager = FirebaseManager.shared
    private let storageManager = StorageManager.shared
    private let collectionName: String = AppConstants.CollectionName.reviews
    private var category: ReviewCategory = .game
        
    init() { }
    
    func submitReview(user: User?, reviewableItem: AvailableAggregateReview, reviewContent: String, reviewRating: Double, images: [Data]?) async {
        
        guard let user else { return }
        
        if reviewableItem is Game {
            category = .game
        } else if reviewableItem is Shop {
            category = .shop
        }
        Task {
            let reviewImages: [String]? = await uploadImages(selectedPhotosData: images)
            
            let review = Review(id: UUID().uuidString,
                                postId: reviewableItem.id,
                                userId: user.id,
                                reviewContent: reviewContent,
                                reviewRating: reviewRating,
                                reviewImage: reviewImages,
                                createdDate: Date(),
                                category: category)
            
            await self.addReview(review: review)
            await self.updateUserReviewCount(user: user)
        }
    }
    
    private func uploadImages(selectedPhotosData: [Data]?) async -> [String]? {
        do {
            guard let selectedPhotosData else { return [] }
            let imagesUrl:[String]? = try await StorageManager.uploadImages(selectedPhotosData, folder: .review)
            return imagesUrl
        } catch {
            print(#fileID, #function, #line, "- 이미지 스토어에 올리기 실패! ")
            return []
        }
    }
    
    // firestore - review 올리기
    @MainActor
    private func addReview(review: Review) async {
        do {
            try firebaseManager.createData(collectionName: collectionName, data: review)
        } catch {
            print("Error add \(collectionName) : \(error.localizedDescription)")
        }
    }
    
    // 리뷰 데이터 가져오기
    @MainActor
    private func fetchReview() async {
        var tempReviews: [Review] = []
        reviews.removeAll()
        do {
            tempReviews = try await firebaseManager.fetchAllData(collectionName: collectionName)
        } catch {
            print("Error fetching \(collectionName) : \(error.localizedDescription)")
        }
        self.reviews = tempReviews
    }
    
    @MainActor
    func fetchReviewData(reviewableItem: AvailableAggregateReview) async {
        Task {
            reviews.removeAll()
            
            var tempReviews: [Review] = []
            
            do {
                tempReviews = try await firebaseManager
                    .fetchWhereIsEqualToData(collectionName: AppConstants.CollectionName.reviews,
                                             field: "postId",
                                             isEqualTo: reviewableItem.id)
            }
            
            // 최신순으로 정렬
            tempReviews.sort { $0.createdDate > $1.createdDate }
            
            for review in tempReviews {
                reviews.append(review)
            }
        }
    }
    
    // Firestore User - myReviewsCount 업데이트
    private func updateUserReviewCount(user: User) async {
        Task {
            do {
                let count: Int = user.myReviewsCount + 1
                
                try await firebaseManager.updateData(collectionName: "Users", byId: user.id, data: ["myReviewsCount": count])
            } catch {
                print(#fileID, #function, #line, "- 파이어베이스 업데이트 실패 ")
            }
        }
    }
    
}
