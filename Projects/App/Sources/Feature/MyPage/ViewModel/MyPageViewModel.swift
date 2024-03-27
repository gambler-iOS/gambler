//
//  MyPageViewModel.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

final class MyPageViewModel: ObservableObject {
    
    @Published var user: User? = User.dummyUser
    @Published var shopReviews: [ReviewData] = []
    @Published var gameReviews: [ReviewData] = []
    @Published var likeShops: [Shop] = []
    @Published var likeGames: [Game] = []
    @Published var userImage: Image?
    @Published var profileImageChanged: Bool = false
    @Published var isShowingToast: Bool = false
    @Published var toastCategory: ToastCategory = .complain

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    private let firebaseManager = FirebaseManager.shared
    private let storageManager = StorageManager.shared
    
    init() { }
    
    @MainActor
    func fetchReviewData() async {
        Task {
            guard let user = Auth.auth().currentUser else { return }
            
            shopReviews.removeAll()
            gameReviews.removeAll()
            
            var tempReviews: [Review] = []
            var name: String = ""
            
            do {
                tempReviews = try await firebaseManager
                    .fetchWhereIsEqualToData(collectionName: AppConstants.CollectionName.reviews,
                                             field: "userId",
                                             isEqualTo: user.uid)
            }
            
            // 최신순으로 정렬
            tempReviews.sort { $0.createdDate > $1.createdDate }
            
            for review in tempReviews {
                if review.category == .game {
                    
                    if let game: Game = try await firebaseManager.fetchOneData(collectionName: "Games", byId: review.postId) {
                        name = game.gameName
                        gameReviews.append(ReviewData(name: name, review: review))
                    }
                } else if review.category == .shop {
                    if let shop: Shop = try await firebaseManager.fetchOneData(collectionName: "Shops", byId: review.postId) {
                        name = shop.shopName
                        shopReviews.append(ReviewData(name: name, review: review))
                    }
                }
            }

        }
    }

}
