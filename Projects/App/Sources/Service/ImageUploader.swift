//
//  ImageUploader.swift
//  gambler
//
//  Created by daye on 3/14/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

struct ImageUploader {
    
    static func uploadImage(_ image: UIImage, type: UploaderType) async throws -> String? {
        
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let fileName = UUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/\(type.path)/\(fileName)")
        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("failed to upload image with error \(error)")
            return nil
        }
    }
    
    static func uploadImages(_ images: [Data], type: UploaderType) async throws -> [String]? {
        var imageUrls: [String] = []
        
        for imageData in images {
            let fileName = UUID().uuidString
            let storageRef = Storage.storage().reference(withPath: "/\(type.path)/\(fileName)")
            
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
    
    
}

enum UploaderType {
    case customerService
    case review
    case user
    
    var path: String {
        switch self {
        case .customerService:
            return "customerService_image"
        case .review:
            return "review_image"
        case .user:
            return "user_image"
        }
    }
}
