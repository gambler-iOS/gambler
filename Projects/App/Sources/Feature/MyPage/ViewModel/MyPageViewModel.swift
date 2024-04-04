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
    @Published var countLike: Int = 0
    @Published var userImage: Image?
    @Published var profileImageChanged: Bool = false
    @Published var isShowingToast: Bool = false
    @Published var toastCategory: ToastCategory = .complain
    @Published var termsOfUserSiteURL: String = "https://raw.githubusercontent.com/gambler-iOS/gambler-WebPage/main/Terms%20of%20Use.md"
    @Published var developerInfoSiteURL: String = "https://github.com/gambler-iOS/gambler"
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    private let firebaseManager = FirebaseManager.shared
    private let storageManager = StorageManager.shared
    
    init() { }
    
    @MainActor
    func fetchLikeCount() {
        countLike = likeGames.count + likeShops.count
    }
    
    @MainActor
    func fetchLikeGames(user: User?) async {
        Task {
            guard let gameIds = user?.likeGameId else { return }
            likeGames.removeAll()
            
            do {
                for gameId in gameIds {
                    if let game: Game = try await firebaseManager
                        .fetchOneData(collectionName: AppConstants.CollectionName.games, byId: gameId) {
                        likeGames.append(game)
                    }
                }
            } catch {
                print("Error fetchLikeGameInfo() MyLikesView : \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func fetchLikeShops(user: User?) async {
        Task {
            guard let shopIds = user?.likeShopId else { return }
            likeShops.removeAll()
            
            do {
                for shopId in shopIds {
                    if let shop: Shop = try await firebaseManager
                        .fetchOneData(collectionName: AppConstants.CollectionName.shops, byId: shopId) {
                        likeShops.append(shop)
                    }
                }
            } catch {
                print("Error fetchLikeShopInfo() MyLikesView : \(error.localizedDescription)")
            }
        }
    }
    
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
