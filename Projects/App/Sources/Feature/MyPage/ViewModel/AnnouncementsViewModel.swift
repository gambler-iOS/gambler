//
//  AnnouncementsViewModel.swift
//  gambler
//
//  Created by daye on 4/3/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation

final class AnnouncementsViewModel: ObservableObject {
    @Published var notices: [Notice] = []
    
    private let firebaseManager = FirebaseManager.shared
    private let collectionName: String = AppConstants.CollectionName.notices
    
    @MainActor
    func fetchData() async {
        do {
            notices = try await firebaseManager.fetchAllData(collectionName: collectionName)
        } catch {
            print("Error fetch AnnouncementsViewModel : \(error.localizedDescription)")
        }
      
    }
    
}
