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
    
    /// 여러 Data Type이미지를 Storage에 올린 후 url 반환
    /// - Parameter images: [UIImage]
    /// - Returns: 이미지 올리기에 성공하면 url 반환, 실패 시 nil 반환
    static func uploadImages(_ images: [Data], folder: StoragePath) async throws -> [String]? {
        var imageUrls: [String] = []
        
        for imageData in images {
            let fileName = UUID().uuidString
            let storageRef = Storage.storage().reference(withPath: "/\(folder)/\(fileName)")
            
            do {
                _ = try await storageRef.putDataAsync(imageData)
                let url = try await storageRef.downloadURL()
                let imageUrl = url.absoluteString
                imageUrls.append(imageUrl)
            } catch {
                print("failed to upload image with error \(error)")
                return nil
            }
        }
        return imageUrls
    }
    
    
//    func uploadImages2(_ images: [Data], folder: StoragePath) async throws -> [String]? {
//        let storageRef = storage.reference()
//        var imageUrls: [String] = []
//
//        // DispatchGroup을 사용하여 모든 이미지 업로드가 완료될 때까지 대기
//        let dispatchGroup = DispatchGroup()
//
//        for imageData in images {
//            let compressedImageData = compressImage(imageData: imageData)
//            let fileName = UUID().uuidString
//            let imageRef = storageRef.child(folder.description).child(fileName)
//
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//
//            // 비동기로 이미지 업로드 시작
//            dispatchGroup.enter()
//            async let uploadTask = imageRef.putDataAsync(compressedImageData, metadata: metadata)
//
//            // 이미지 업로드 완료 후 처리
//            Task {
//                    let _ = imageRef.putData(compressedImageData, metadata: metadata)
//  // 업로드 완료까지 대기
//                    let url = try await imageRef.downloadURL()  // 이미지 다운로드 URL 가져오기
//                    let imageUrl = url.absoluteString
//                    imageUrls.append(imageUrl)
//                // DispatchGroup에서 해당 작업이 끝났음을 알림
//                dispatchGroup.leave()
//            }
//        }
//        // 모든 이미지 업로드가 완료될 때까지 대기
//        await dispatchGroup.wait()
//        return imageUrls.isEmpty ? nil : imageUrls
//    }
    
    
    func compressImage(imageData: Data) -> Data {
        guard let image = UIImage(data: imageData) else {
            print("Invalid image data")
            return imageData
        }
        
        if let compressedImageData = image.jpegData(compressionQuality: 0.25) {
            return compressedImageData
        } else {
            print("Error compressing image")
            return imageData
        }
    }
}
