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

    private let db = Firestore.firestore()
    
    private init() {
    }

    func createData<T: AvailableFirebase>(collectionName: String, data: T) throws {
        let documentRef = db.collection(collectionName).document(data.id)
        try documentRef.setData(from: data)
    }

    func fetchAllData<T: AvailableFirebase>(collectionName: String, objectType: T.Type) async -> [T] {
        do {
            let querySnapshot = try await db.collection(collectionName).getDocuments()
            let data = querySnapshot.documents.compactMap { try? $0.data(as: objectType) }
            return data
        } catch {
            print("Error fetching \(collectionName): \(error.localizedDescription)")
        }
        return []
    }

    // TODO: error handler 만들어야하나
    func fetchOrderData<T: AvailableFirebase>(collectionName: String, objectType: T.Type, orderBy: String, limit: Int?)
    async -> [T] {
        do {
            var collectionRef = db.collection(collectionName)
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

    func fetchWhereData<T: AvailableFirebase>(collectionName: String, objectType: T.Type, field: String,
                                              isEqualTo data: String) async -> [T] {
        do {
            let querySnapshot = try await db.collection(collectionName)
                .whereField(field, isEqualTo: data).getDocuments()
            let data = querySnapshot.documents.compactMap { try? $0.data(as: objectType) }
            return data
        } catch {
            print("Error fetching \(collectionName): \(error.localizedDescription)")
        }
        return []
    }

    func fetchOneData<T: AvailableFirebase>(collectionName: String, objectType: T.Type, byId: String) async -> T? {
        do {
            let querySnapshot = try await db.collection(collectionName)
                .whereField("id", isEqualTo: byId).getDocuments()
            let data = querySnapshot.documents.compactMap { try? $0.data(as: objectType) }
            return data[0]
        } catch {
            print("Error fetching \(collectionName): \(error.localizedDescription)")
        }
        return nil
    }

    func updateData<T: AvailableFirebase>(collectionName: String, objectType: T.Type, byId: String,
                                          data: [AnyHashable: Any]) async throws {
        try await db.collection(collectionName).document(byId).updateData(data)
    }
    //    func getProfileImageURL(path: ImagePath, fileName:String) -> String {
    //        Storage.storage().reference().child(path.rawValue + fileName).fullPath
    //    }
    
    
    /// 파이어스토어에 원하는 다큐먼트가 있는지 확인
    /// - Parameters:
    ///   - collectionName: 콜렉션 이름
    ///   - byId: 다큐먼트이름 - id로 설정
    /// - Returns: Bool - 있으면 true / 없으면 false
    func checkDocumentExists(collectionName: String, byId: String, completion: @escaping (Bool, Error?) -> Void) {
        // 파이어스토어에 있는 특정 다큐먼트를 참조합니다.
        let docRef = db.collection(collectionName).document(byId)
        
        // 해당 다큐먼트의 데이터를 가져오는 메서드를 호출합니다.
        docRef.getDocument { (document, error) in
            if let error = error {
                // 에러가 발생한 경우
                completion(false, error)
            } else if let document = document, document.exists {
                // 다큐먼트가 존재하는 경우
                completion(true, nil)
            } else {
                // 다큐먼트가 존재하지 않는 경우
                completion(false, nil)
            }
        }
    }
}
