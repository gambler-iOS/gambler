//
//  AuthService.swift
//  gambler
//
//  Created by 박성훈 on 3/5/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn

enum AuthState {
    case signedIn
    case signedOut
    case creatingAccount
}

final class AuthService: ObservableObject {
    
    static let shared = AuthService()
    
    var tempUser: User?  // 회원가입 시 유저 데이터를 담을 임시 변수
    
    private init() { }
    
    func setTempUser(id: String, nickname: String, profileImage: String, apnsToken: String?, loginPlatform: LoginPlatform) async {
        tempUser = User(id: id,
                        nickname: nickname,
                        profileImageURL: profileImage,
                        apnsToken: apnsToken,
                        createdDate: Date(),
                        likeGameId: [],
                        likeShopId: [],
                        myReviewsCount: 0,
                        myLikesCount: 0,
                        loginPlatform: loginPlatform)
    }
    
    /// 이메일 로그인
    func loginWithEmail(email: String, password: String, name: String, profileImageURL: String) async -> Bool {
        await withCheckedContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error {
                    print(error.localizedDescription)
                    print("로그인 실패???")
                    continuation.resume(returning: false)
                }
                
                if let result {
                    Task {
                        print("카카오톡 로그인 성공")
                        await self.setTempUser(id: result.user.uid,
                                               nickname: name,
                                               profileImage: profileImageURL,
                                               apnsToken: "카카오",
                                               loginPlatform: .kakakotalk)
                        continuation.resume(returning: true)
                    }
                }
            }
        }
    }
    
    func createUser(email: String, password: String, name: String, profileImageURL: String) async {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            Task {
                if let error {
                    print("DEBUG: 파이어베이스 사용자 생성 실패 \(error.localizedDescription)")
                } else {
                    print("DEBUG: 파이어베이스 사용자 생성")
                    guard let uid = result?.user.uid else { return }
                    
                    await self.setTempUser(id: uid,
                                           nickname: name,
                                           profileImage: profileImageURL,
                                           apnsToken: "카카오",
                                           loginPlatform: .kakakotalk)
                }
            }
        }
    }
    
    func signOut() async {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
//    func deleteAuth() async -> Bool {
//        await withCheckedContinuation { continuation in
//            guard let user = Auth.auth().currentUser else {
//                continuation.resume(returning: false)
//                return
//            }
//            
//            user.delete() { error in
//                Task {
//                    if let error = error {
//                        print("2번 문제")
//                        print(error.localizedDescription)
//                        continuation.resume(returning: false)
//                    } else {
//                        print("삭제 성공")
//                        continuation.resume(returning: true)
//                    }
//                }
//            }
//        }
//    }
    
    func uploadUserToFirestore(user: User) {
        do {
            try FirebaseManager.shared.createData(collectionName: "Users", data: user)
        } catch {
            print("Firestore에 올리기 실패, \(error)")
        }
    }
}
