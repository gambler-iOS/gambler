//
//  MyPageViewModel.swift
//  gambler
//
//  Created by 박성훈 on 1/27/24.
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
    
    @Published var user: User = User(nickname: "")
    
//    @Published var selectedImage: PhotosPickerItem? {
//            didSet { Task {try await loadImage(fromItem: selectedImage)} }
//        }
//    @Published var profileImage: Image = Image("no_profile")
    private var uiImage: UIImage?

    init() {
        user = generateDummyData()
    }
    
    private func generateDummyData() -> User {
        User(nickname: "성훈", profileImageURL: "https://cdn-icons-png.flaticon.com/512/21/21104.png", apsToken: "카카오톡", createdDate: Date(), likeGameIds: [], likeShopIds: [])
    }
    
    // 프로필 이미지 올리기
    func loadImage(fromItem item: PhotosPickerItem?) async throws{
            guard let item = item else { return }
            guard let data = try? await item.loadTransferable(type: Data.self) else { return }
            guard let uiImage = UIImage(data: data) else { return }
            self.uiImage = uiImage
//            self.profileImage = Image(uiImage: uiImage)
            try await updateProfileImage()
    }
    
    // 수정 필요
    private func updateProfileImage() async throws {
            guard let image = self.uiImage else { return }
            guard let imageUrl = try? await ImageUploader.uploadImage(image) else { return }
            try await updateUserProfileImage(withImageUrl: imageUrl)
    }
    
    @MainActor
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("Users").document(currentUid).updateData([
            "profileImageName": imageUrl
        ])
//        self.currentUser?.profileImageName = imageUrl
    }
    
}
