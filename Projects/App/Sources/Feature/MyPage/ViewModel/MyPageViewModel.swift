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
//import FirebaseCore
import FirebaseFirestore
//import FirebaseFirestoreSwift

final class MyPageViewModel: ObservableObject {
 
    enum LikeCategory: String, CaseIterable {
        case shop = "매장"
        case game = "게임"
    }
    
    @Published var user: User = User.dummyUser
    @Published var shopReviews: [Review] = []
    @Published var gameReviews: [Review] = []
    @Published var likeShops: [Shop] = []
    @Published var likeGames: [Game] = []
    var appVersion: String = "1.0.1"
    
    var numnberOfReviews: String = ""
    var numberOfLikes: String = ""
    
    init() {
        self.numnberOfReviews = getNumberOfReviews()
        self.numberOfLikes = getNumberOfLikes()
        generateDummyData()
    }
    
    private func generateDummyData() {
        for _ in 1...4 {
            shopReviews.append(Review.dummyShopReview)
            gameReviews.append(Review.dummyGameReview)
            likeShops.append(Shop.dummyShop)
            likeGames.append(Game(
                id: UUID().uuidString,
                gameName: "아임 더 보스",
                gameImage: "https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186",
                descriptionImage: ["image"],
                gameLink: "link",
                createdDate: Date(),
                reviewCount: 5,
                reviewRatingAverage: 3.5,
                gameIntroduction: GameIntroduction(
                    difficulty: 3.1,
                    minPlayerCount: 2,
                    maxPlayerCount: 4,
                    playTime: 2,
                    genre: .fantasy)
                ))
        }
    }
    
    private func getNumberOfReviews() -> String {
        // 이거는 파이어베이스에서 읽어서 카운트 해야함
        return "10"
    }
    
    private func getNumberOfLikes() -> String{
        let numberOfReviewInt = user.likeGameId.count + user.likeShopId.count
        return "\(numberOfReviewInt)"
    }
    
    
//    @Published var selectedImage: PhotosPickerItem? {
//            didSet { Task {try await loadImage(fromItem: selectedImage)} }
//        }
//    @Published var profileImage: Image = Image("no_profile")
    private var uiImage: UIImage?

//    init() {
//        user = generateDummyData()
//    }
//    
//    private func generateDummyData() -> User {
//        User(nickname: "성훈", profileImageURL: "https://cdn-icons-png.flaticon.com/512/21/21104.png", apsToken: "카카오톡", createdDate: Date(), likeGameIds: [], likeShopIds: [])
//    }
//    
    // 프로필 이미지 올리기
//    func loadImage(fromItem item: PhotosPickerItem?) async throws{
//            guard let item = item else { return }
//            guard let data = try? await item.loadTransferable(type: Data.self) else { return }
//            guard let uiImage = UIImage(data: data) else { return }
//            self.uiImage = uiImage
////            self.profileImage = Image(uiImage: uiImage)
//            try await updateProfileImage()
//    }
    
    // 수정 필요
//    private func updateProfileImage() async throws {
//            guard let image = self.uiImage else { return }
//            guard let imageUrl = try? await ImageUploader.uploadImage(image) else { return }
//            try await updateUserProfileImage(withImageUrl: imageUrl)
//    }
//    
//    @MainActor
//    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//        try await Firestore.firestore().collection("Users").document(currentUid).updateData([
//            "profileImageName": imageUrl
//        ])
////        self.currentUser?.profileImageName = imageUrl
//    }
    
}
