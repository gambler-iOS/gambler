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
    
    var dummyUser: User?
    
    // 1. 이 리스너는 사용자의 로그인 상태가 바뀔 때마다 호출됨
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    
    /// Common auth link errors.
    private let authLinkErrors: [AuthErrorCode.Code] = [
        .emailAlreadyInUse,
        .credentialAlreadyInUse,
        .providerAlreadyLinked
    ]
    
    private init() { }
    
    func addDummyData(id: String, nickname: String, profileImage: String, apnsToken: String?, loginPlatform: LoginPlatform) async {
        dummyUser = User(id: id,
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
    func loginWithEmail(email: String, password: String) async -> Bool {
        await withCheckedContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error {
                    print(error.localizedDescription)
                    continuation.resume(returning: false)
                }
                
                if let result {
                    print("카카오톡 로그인 성공")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor
    func loginFirebase(email: String, password: String, name: String, profileImageURL: String) async {
        Task {
            if await loginWithEmail(email: email, password: password) {
                // 로그인 성공
                print(#fileID, #function, #line, "- email 로그인 성공 ~~~ ")
            } else {
                // 로그인 실패 - 회원가입 해야함
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error {
                        print("DEBUG: 파이어베이스 사용자 생성 실패 \(error.localizedDescription)")
//                        Auth.auth().signIn(withEmail: email, password: password)
                        print("카카오톡 로그인 성공")
                        // 여기서 패치해야하나
                    } else {
                        print("DEBUG: 파이어베이스 사용자 생성")
                        guard let uid = result?.user.uid else { return }
                        
                        self.dummyUser = User(id: uid,
                                              nickname: name,
                                              profileImageURL: profileImageURL,
                                              apnsToken: "",
                                              createdDate: Date(),
                                              likeGameId: [],
                                              likeShopId: [],
                                              myReviewsCount: 0,
                                              myLikesCount: 0,
                                              loginPlatform: .kakakotalk)
                    }
                }
            }
            
        }
    }
    
    
    /// 이메일 회원가입(FirebaseStore에도 등록) ->  카카오가입할때
    @MainActor
    func createUser(email: String, password: String, name: String, profileImageURL: String) async{
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("DEBUG: 파이어베이스 사용자 생성 실패 \(error.localizedDescription)")
                Auth.auth().signIn(withEmail: email, password: password)
                print("카카오톡 로그인 성공")
                // 여기서 패치해야하나
            } else {
                print("DEBUG: 파이어베이스 사용자 생성")
                guard let uid = result?.user.uid else { return }
                
                self.dummyUser = User(id: uid,
                                      nickname: name,
                                      profileImageURL: profileImageURL,
                                      apnsToken: "",
                                      createdDate: Date(),
                                      likeGameId: [],
                                      likeShopId: [],
                                      myReviewsCount: 0,
                                      myLikesCount: 0,
                                      loginPlatform: .kakakotalk)
                
            }
        }
    }
    
    func uploadUserToFirestore(user: User) {
        do {
            try FirebaseManager.shared.createData(collectionName: "Users", data: user)
        } catch {
            print("Firestore에 올리기 실패, \(error)")
        }
    }
}
