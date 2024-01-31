//
//  FirebaseManager.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseManager {
    static let shared = FirebaseManager()

    private init() {
    }

    func createData<T: AvailableFirebase>(collectionName: String, data: T) throws {
        let documentRef = Firestore.firestore().collection(collectionName).document(data.id)
        try documentRef.setData(from: data)
    }

    func fetchAllData<T: AvailableFirebase>(collectionName: String, objectType: T.Type) async -> [T] {
        do {
            let querySnapshot = try await Firestore.firestore().collection(collectionName).getDocuments()
            let data = querySnapshot.documents.compactMap { try? $0.data(as: objectType) }
            return data
        } catch {
            print("Error fetching \(collectionName): \(error.localizedDescription)")
        }
        return []
    }

    // TODO: error handler 만들어야하나
    func fetchData<T: AvailableFirebase>(collectionName: String, objectType: T.Type, orderBy: String, limit: Int?)
    async -> [T] {
        do {
            var collectionRef = Firestore.firestore().collection(collectionName)
                .order(by: orderBy, descending: true)
            if let limit {
                collectionRef = collectionRef.limit(to: limit)
            }
            let querySnapshot = try await collectionRef.getDocuments()
            let data = querySnapshot.documents.compactMap { try? $0.data(as: objectType) }
            return data
        } catch {
            print("Error fetching \(collectionName): \(error.localizedDescription)")
        }
        return []
    }

    func fetchOneData<T: AvailableFirebase>(collectionName: String, objectType: T.Type, byId: String) async -> T? {
        do {
            let querySnapshot = try await Firestore.firestore().collection(collectionName)
                .whereField("id", isEqualTo: byId).getDocuments()
            let data = querySnapshot.documents.compactMap { try? $0.data(as: objectType) }
            return data[0]
        } catch {
            print("Error fetching \(collectionName): \(error.localizedDescription)")
        }
        return nil
    }
    //    func getProfileImageURL(path: ImagePath, fileName:String) -> String {
    //        Storage.storage().reference().child(path.rawValue + fileName).fullPath
    //    }
}
