//
//  FirebaseAuthManager.swift
//  gambler
//
//  Created by 박성훈 on 3/2/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
//import Firebase
import FirebaseAuth

final class FirebaseAuthManager {
    
//    static let shared = FirebaseAuthManager()
//
//    private init() { }
//    
//    func emailAuthSignUp(email: String, nickname: String, password: String, profileImageURL: String?, apnsToken: String, completion: (() -> Void)?) {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error {
//                print("error: \(error.localizedDescription)")
//            }
//            if result != nil {
//                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//                changeRequest?.displayName = nickname
//                print("사용자 이메일: \(String(describing: result?.user.email))")
//                
//                Task {
//                    await self.createUserFirebase(nickname: nickname, profileImageURL: profileImageURL ?? "", apnsToken: apnsToken)
//                }
//            }
//            
//            completion?()
//        }
//    }
//    
//    func emailAuthSignIn(email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error {
//                print("error: \(error.localizedDescription)")
//                
//                return
//            }
//            
//            if result != nil {
//                self.state = .signedIn
//                print("사용자 이메일: \(String(describing: result?.user.email))")
//                print("사용자 이름: \(String(describing: result?.user.displayName))")
//                
//            }
//        }
//    }
//    
//    private func createUserFirebase(nickname: String, profileImageURL: String, apnsToken: String) async {
//        do {
//            try firebaseManager.createData(
//                collectionName: "Users",
//                data: User(
//                    id: UUID().uuidString,
//                    nickname: nickname,
//                    profileImageURL: profileImageURL,
//                    apnsToken: apnsToken,
//                    createdDate: Date(),
//                    likeGameId: nil,
//                    likeShopId: nil,
//                    myReviewsCount: 0,
//                    myLikesCount: 0,
//                    loginPlatform: .kakakotalk)
//            )
//        } catch {
//            print("\(error)")
//        }
//        
//    }
}
