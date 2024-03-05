//
//  AuthService.swift
//  gambler
//
//  Created by 박성훈 on 3/5/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import FirebaseAuth

final class AuthService {
    static let shared = AuthService()
    
    private init() { }
    
    /// 이메일 로그인
    func loginWithEmail(email: String, password: String) async -> Bool {
        await withCheckedContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error {
                    print(error.localizedDescription)
                    continuation.resume(returning: false)
                }
                
                if let _ = result {
                    print("카카오톡 로그인 성공")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    /// 이메일 회원가입(FirebaseStore에도 등록) ->  카카오가입할때
    @MainActor
    func createUser(email: String, password: String, name: String, profileImageURL: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            uploadUserToFirestore(userId: result.user.uid,
                                  name: name,
                                  profileImageURL: profileImageURL,
                                  apnsToken: "카카오톡",
                                  loginPlatform: .kakakotalk)
            print("회원가입 성공")
        } catch {
            print("회원가입 실패. 에러메세지: \(error.localizedDescription)")
            throw error
        }
    }
    
    func uploadUserToFirestore(userId: String, name: String, profileImageURL: String, apnsToken: String, loginPlatform: LoginPlatform) {
        
        let user = User(id: userId,
                        nickname: name,
                        profileImageURL: profileImageURL,
                        apnsToken: apnsToken,
                        createdDate: Date(),
                        likeGameId: [],
                        likeShopId: [],
                        myReviewsCount: 0,
                        myLikesCount: 0,
                        loginPlatform: loginPlatform
        )
        
        do {
            try FirebaseManager.shared.createData(collectionName: "Users", data: user)
        } catch {
            print("Firestore에 올리기 실패, \(error)")
        }
    }
}
