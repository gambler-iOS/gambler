//
//  FirestorageManager.swift
//  gambler
//
//  Created by 박성훈 on 3/6/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import PhotosUI

enum StoragePath {
    case user
    case review
    case shop
    case game
    case complain
    case eventBanner
    
    var description: String {
        switch self {
        case .user:
            return "Users"
        case .review:
            return "Reviews"
        case .shop:
            return "Shops"
        case .game:
            return "Games"
        case .complain:
            return "Complains"
        case .eventBanner:
            return "EventBanners"
        }
    }
    
    var fieldName: String {  // game, shop은 개인이미지, 여러이미지들이 있음...
        switch self {
        case .user:
            return "profileImageURL"
        case .review:
            return "reviewImage"
        case .shop:
            return "shopImage"
        case .game:
            return "gameImage"
        case .complain:
            return "complainImage"
        case .eventBanner:
            return "bannerImage"
        }
    }
}

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage()
    private var uiImage: UIImage?
    
    private init() { }
    
    #warning("해당 메서드 사용 후, 데이터 패치해와야 함")
    /// 프로필 이미지 스토지에 저장, 스토어에 업데이트, 사용 후 패치해야함
    /// - Parameter item: PhotosPickerItem?
    func loadProfileImage(fromItem item: PhotosPickerItem?, folder: StoragePath) async throws {
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        try await updateProfileImage(folder: folder)
    }

    #warning("Field도 enum으로 만들어야할지")
    #warning("이미지 여러개 올리는 부분은 미완성입니다... 주석부분")
//    func loadImages(fromItems items: [PhotosPickerItem], folder: StoragePath, collectionName: String) async throws {
//        
//        var images: [UIImage] = []
//        
//        guard !items.isEmpty else { return }  // 비어있다면
//        
//        for item in items {
//            guard let data = try? await item.loadTransferable(type: Data.self) else { continue }
//            guard let uiImage = UIImage(data: data) else { continue }
//            images.append(uiImage)
//        }
//        
//        try await updateImages(images: images, folder: folder, collectionName: collectionName)
//    }
//    
//    /// 이미지들을 스토어에 업데이트
//    private func updateImages(images: [UIImage], folder: StoragePath, collectionName: String) async throws {
//        guard !images.isEmpty else { return }
//        
//        guard let imageUrl = try? await self.uploadImages(images, folder: folder) else { return }
//        
//        // 여기서 id가 뭐징
//        try await FirebaseManager.shared.updateData(collectionName: "Users", objectType: User.self, byId: currentUid, data: [folder.fieldName: imageUrl]) // 여기는 배열인데
//    }
    
    
    
    /// 프로필 이미지를 스토어에 업데이트
    private func updateProfileImage(folder: StoragePath) async throws {
        guard let image = self.uiImage else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        guard let imageUrl = try? await self.uploadImage(image, folder: folder) else { return }
        try await FirebaseManager.shared.updateData(collectionName: "Users", byId: currentUid,
                                                    data: ["profileImageURL": imageUrl])
    }
    
    /// 이미지를 Storage에 올린 후 url 반환
    /// - Parameter image: UIImage
    /// - Returns: 업로드 성공시 url 반환, 실패 시 nil 반환
    private func uploadImage(_ image: UIImage, folder: StoragePath) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let fileName = UUID().uuidString
        let storageRef = storage.reference().child(folder.description).child(fileName)
        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("failed to upload image with error \(error)")
            return nil
        }
    }
    
    /// 여러 이미지를 Storage에 올린 후 url 반환
    /// - Parameter images: [UIImage]
    /// - Returns: 이미지 올리기에 성공하면 url 반환, 실패 시 nil 반환
    private func uploadImages(_ images: [UIImage], folder: StoragePath) async -> [String]? {
        
        var imageURLs: [String] = []
        for image in images {
            do {
                if let imageUrl = try await uploadImage(image, folder: folder) {
                    print("Image uploaded successfully. URL: \(imageUrl)")
                    imageURLs.append(imageUrl)
                } else {
                    print("Failed to upload image.")
                }
            } catch {
                print("Error uploading image: \(error)")
            }
        }
        
        if imageURLs.isEmpty {
            return nil
        } else {
            return imageURLs
        }
    }
    
    
}
