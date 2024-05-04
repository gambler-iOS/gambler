//
//  ComplainViewModel.swift
//  gambler
//
//  Created by daye on 3/13/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation

final class ComplainViewModel {
    private let firebaseManager = FirebaseManager.shared
    private let collectionName: String = AppConstants.CollectionName.complains
 
    func addData(complain: Complain) async {
        do {
            try firebaseManager.createData(collectionName: collectionName, data: complain)
        } catch {
            print("Error add ComplainViewModel : \(error.localizedDescription)")
        }
    }
    
}
