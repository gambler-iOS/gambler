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
import CoreLocation

final class FirebaseManager {
    static let shared = FirebaseManager()

    private let db = Firestore.firestore()
    
    private init() {
    }

    /// collectionName 에 데이터 생성
    /// - Parameters:
    ///   - collectionName: FirebaseStore 에서 지정된 Collection 이름
    ///   - data: 생성할 model 객체
    /// - Example:
    /// ```swift
    /// createData(collectionName: "Users", data: user)
    /// ```
    func createData<T: AvailableFirebase>(collectionName: String, data: T) throws {
        let documentRef = db.collection(collectionName).document(data.id)
        try documentRef.setData(from: data)
    }

    /// collectionName 에 지정한 collection 전체 데이터 fetch
    /// - Parameters:
    ///   - collectionName: FirebaseStore 에서 지정된 Collection 이름
    /// - Returns: [T]
    /// - Example:
    /// ```swift
    /// fetchAllData(collectionName: "Games")
    /// ```
    func fetchAllData<T: AvailableFirebase>(collectionName: String) async throws -> [T] {
        let querySnapshot = try await db.collection(collectionName).getDocuments()
        let result = querySnapshot.documents.compactMap { try? $0.data(as: T.self) }
        return result
    }

    /// 지정한 collecion 에서 orderby 기준으로 descending 정렬해서 fetch
    /// - Parameters:
    ///   - collectionName: FirebaseStore 에서 지정된 Collection 이름
    ///   - orderBy: 정렬할 데이터의 field
    ///   - limit: 가져오는 데이터 개수 제한할 때 사용 (옵셔널)
    /// - Returns: [T]
    /// - Example:
    /// ```swift
    /// fetchOrderData(collectionName: AppConstants.CollectionName.games, orderBy: "reviewCount", limit: 5)
    /// ```
    func fetchOrderData<T: AvailableFirebase>(collectionName: String, orderBy: String,
                                              limit: Int? = nil) async throws -> [T] {
        var collectionRef = db.collection(collectionName)
            .order(by: orderBy, descending: true)
        if let limit {
            collectionRef = collectionRef.limit(to: limit)
        }
        let querySnapshot = try await collectionRef.getDocuments()
        let result = querySnapshot.documents.compactMap { try? $0.data(as: T.self) }
        return result
    }

    /// 지정한 collection 에서 지정한 field 와 한 개의 입력한 데이터가 일치하는 데이터들을 fetch
    /// - Parameters:
    ///   - collectionName: FirebaseStore 에서 지정된 Collection 이름
    ///   - field: 비교할 데이터의 field
    ///   - isEqualTo : 비교할 데이터
    ///   - orderBy: 정렬할 데이터의 field
    ///   - limit: 가져오는 데이터 개수 제한할 때 사용 (옵셔널)
    /// - Returns: [T]
    /// - Example:
    /// ```swift
    /// fetchWhereIsEqualToData(collectionName: "Users", field: "nickname", isEqualTo: "nick name string")
    /// ```
    func fetchWhereIsEqualToData<T: AvailableFirebase>(collectionName: String, field: String, isEqualTo data: Any,
                                                       orderBy: String? = nil, limit: Int? = nil) async throws -> [T] {
        var collectionRef = db.collection(collectionName)
            .whereField(field, isEqualTo: data)
        if let orderBy {
            collectionRef = collectionRef.order(by: orderBy, descending: true)
        }
        if let limit {
            collectionRef = collectionRef.limit(to: limit)
        }
        let querySnapshot = try await collectionRef.getDocuments()
        let result = querySnapshot.documents.compactMap { try? $0.data(as: T.self) }
        return result
    }
    
    /// 지정한 collection 에서 지정한 field 와 입력한 배열 데이터 중 한 개 이상 일치하는 데이터들을 fetch
    /// - Parameters:
    ///   - collectionName: FirebaseStore 에서 지정된 Collection 이름
    ///   - field: 비교할 데이터의 field
    ///   - arrayContainsAny : 비교할 데이터들이 담긴 배열 (enum 비교까지 커버하기 위해 in 이 아닌 arrayContainsAny 사용)
    ///   - limit: 가져오는 데이터 개수 제한할 때 사용 (옵셔널)
    /// - Returns: [T]
    /// - Example:
    /// ```swift
    /// fetchWhereArrayContainsData(collectionName: "Users", field: "likeGameId", in: ["333","555"], limit: 5)
    /// ```
    func fetchWhereArrayContainsData<T: AvailableFirebase>(collectionName: String, field: String,
                                                           arrayContainsAny data: [Any],
                                                           limit: Int? = nil) async throws -> [T] {
        var collectionRef = db.collection(collectionName)
            .whereField(field, arrayContainsAny: data)
        if let limit {
            collectionRef = collectionRef.limit(to: limit)
        }
        let querySnapshot = try await collectionRef.getDocuments()
        let result = querySnapshot.documents.compactMap { try? $0.data(as: T.self) }
        return result
    }

    /// 지정한 collection 에서 byId 와 일치하는 데이터들을 fetch 한 후 처음 데이터만 리턴, 일치하는 데이터가 없다면 nil 리턴
    /// - Parameters:
    ///   - collectionName: FirebaseStore 에서 지정된 Collection 이름
    ///   - byId: id 필드와 비교할 id 값
    /// - Returns: T?
    /// - Example:
    /// ```swift
    /// fetchOneData(collectionName: AppConstants.CollectionName.games, byId: game.id)
    /// ```
    func fetchOneData<T: AvailableFirebase>(collectionName: String, byId: String) async throws -> T? {
        let querySnapshot = try await db.collection(collectionName)
            .whereField("id", isEqualTo: byId).getDocuments()
        let result = querySnapshot.documents.compactMap { try? $0.data(as: T.self) }
        return result.first ?? nil
    }
    
    /// 지정한 collection 에서 임의의 1개의 데이터만 리턴
    /// - Parameters:
    ///   - collectionName: FirebaseStore 에서 지정된 Collection 이름
    /// - Returns: T?
    /// - Example:
    /// ```swift
    /// fetchOneAnyData(collectionName: AppConstants.CollectionName.shops)
    /// ```
    func fetchOneAnyData<T: AvailableFirebase>(collectionName: String) async throws -> T? {
        let collectionRef = db.collection(collectionName).limit(to: 1)
        let querySnapshot = try await collectionRef.getDocuments()
        let result = querySnapshot.documents.compactMap { try? $0.data(as: T.self) }
        return result.first ?? nil
    }

    /// 지정한 collection 에서 byId 와 일치하는 문서의 feild 데이터를 data 입력값으로 변경
    /// - Parameters:
    ///   - collectionName: FirebaseStore 에서 지정된 Collection 이름
    ///   - byId: id 필드와 비교할 id 값
    ///   - data: 변경할 데이터를 dictionary 형태 ["필드이름": 값] 로 입력
    /// - Example:
    /// ```swift
    /// updateData(collectionName: "Users", byId: currentUid, data: ["profileImageURL": imageUrl])
    /// ```
    func updateData(collectionName: String, byId: String, data: [AnyHashable: Any]) async throws {
        try await db.collection(collectionName).document(byId).updateData(data)
    }
    
    /// 지정한 collection 에서 byId 와 일치하는 문서 삭제
    /// - Parameters:
    ///   - collectionName: FirebaseStore 에서 지정된 Collection 이름
    ///   - byId: id 필드와 비교할 id 값
    /// - Example:
    /// ```swift
    /// deleteData(collectionName: "Users", byId: user.uid)
    /// ```
    func deleteData(collectionName: String, byId: String) async throws {
            try await db.collection(collectionName).document(byId).delete()
    }
}
