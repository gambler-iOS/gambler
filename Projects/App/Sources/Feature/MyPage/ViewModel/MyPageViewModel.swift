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
        for _ in 1...5 {
            shopReviews.append(Review(id: UUID().uuidString,
                                      postId: UUID().uuidString,
                                      userId: UUID().uuidString,
                                      reviewContent: "강남역에서 엄청 가깝고 시설도 좋더라구요~ 게임도 많아서 오랫동안 있었네요! 알바생도 친절해서 좋았어요, 다음에도 선릉점으로 가려구요",
                                      reviewRating: 4.5,
                                      reviewImage: ["https://beziergames.com/cdn/shop/products/UltimateAccessoryPack_800x.png?v=1587055236"],
                                      createdDate: Date()
                           ))
            
            gameReviews.append(Review(id: UUID().uuidString,
                                      postId: UUID().uuidString,
                                      userId: UUID().uuidString,
                                      reviewContent: "친구 3명이랑 했는데 일반 마피아보다 색달라서 재밌었어요. 쉬운 게임이여서 진입장벽 없이 바로 할 수 있음요 ~!",
                                      reviewRating: 4.0,
                                      reviewImage: ["https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186"],
                                      createdDate: Date()
))
            
            likeShops.append(Shop(
                id: UUID().uuidString,
                shopName: "레드버튼 강남점",
                shopAddress: "address",
                shopImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
                location: GeoPoint(latitude: 120.1, longitude: 140),
                shopPhoneNumber: "010-5555", menu: ["커피": 1000],
                openingHour: "10시",
                amenity: ["주차"],
                shopDetailImage: ["detailImage"],
                createdDate: Date(),
                reviewCount: 3,
                reviewRatingAverage: 3.5))
            
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
