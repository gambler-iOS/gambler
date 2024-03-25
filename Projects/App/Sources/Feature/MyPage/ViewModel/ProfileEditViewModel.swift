//
//  ProfileEditViewModel.swift
//  gambler
//
//  Created by 박성훈 on 3/25/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI
import PhotosUI

final class ProfileEditViewModel: ObservableObject {
    @Published var imageData: Data?
    @Published var selectedPhoto: PhotosPickerItem?
    
    private let firebaseManager = FirebaseManager.shared
    private let storageManager = StorageManager.shared
    
    init() { }
    
    @MainActor
    func uploadProfileImage(user: User?, selectedPhoto: PhotosPickerItem?) async -> Bool  {
        await withCheckedContinuation { continuation in
            Task {
                do {
                    guard let user else { return }
                    guard let selectedPhoto else { return }
                    
                    try await storageManager.loadProfileImage(fromItem: selectedPhoto, folder: .user)
                    continuation.resume(returning: true)
                } catch {
                    print(#fileID, #function, #line, "- 유저 이미지 업데이트 실패")
                }
            }
        }
    }
}
