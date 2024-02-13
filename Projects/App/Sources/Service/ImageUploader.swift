//
//  ImageUploader.swift
//  gambler
//
//  Created by 박성훈 on 2/13/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

struct ImageUploader {
    
    static func uploadImage(_ image: UIImage) async throws -> String? {
        
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let fileName = UUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "profile_image/\(fileName)")
        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("failed to upload image with error \(error)")
            return nil
        }
    }
    
    static func uploadPostImage(image: UIImage) async throws -> String? {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
            let filename = NSUUID().uuidString
            let ref = Storage.storage().reference(withPath: "/post_images/\(filename)")
            do {
                let _ = try await ref.putDataAsync(imageData)
                let url = try await ref.downloadURL()
                return url.absoluteString
            } catch {
                print("failed to upload image with error \(error.localizedDescription)")
                return nil
            }
        }
}
