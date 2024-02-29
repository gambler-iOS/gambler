//
//  LoginViewModel.swift
//  gambler
//
//  Created by 박성훈 on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser

enum SignInState {
    case signedIn
    case signedOut
}

final class LoginViewModel: ObservableObject {
    @Published var currentUser: Firebase.User?
    @Published var state: SignInState = .signedOut
    @Published var loginPlatoform: LoginPlatform = .apple
    
    private let firebaseManager = FirebaseManager.shared
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    // MARK: - FirebaseAuth Function
      // completionHandler (클로저)를 통한 비동기 방식으로 실행
      func emailAuthSignUp(email: String, nickname: String, password: String, profileImageURL: String?, appsToken: String, completion: (() -> Void)?) {
          Auth.auth().createUser(withEmail: email, password: password) { result, error in
              if let error {
                  print("error: \(error.localizedDescription)")
              }
              if result != nil {
                  let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                  changeRequest?.displayName = nickname
                  print("사용자 이메일: \(String(describing: result?.user.email))")
                  
                  Task {
                      await self.createUserFirebase(nickname: nickname, profileImageURL: profileImageURL ?? "", appsToken: appsToken)
                  }
              }
              
              completion?()
          }
      }
      
      func emailAuthSignIn(email: String, password: String) {
          Auth.auth().signIn(withEmail: email, password: password) { result, error in
              if let error {
                  print("error: \(error.localizedDescription)")
                  
                  return
              }
              
              if result != nil {
                  self.state = .signedIn
                  print("사용자 이메일: \(String(describing: result?.user.email))")
                  print("사용자 이름: \(String(describing: result?.user.displayName))")
                  
              }
          }
      }
      
      // MARK: - KakaoAuth SignIn Function
      @MainActor
      func kakaoAuthSignIn() {
          if AuthApi.hasToken() { // 발급된 토큰이 있는지
              UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
                  if let error = error { // 에러가 발생했으면 토큰이 유효하지 않다.
                      Task {
                          if UserApi.isKakaoTalkLoginAvailable() {
                              if await self.handleSignInWithKakaoTalkApp() {
                                  self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
                              }
                          } else {
                              if await self.handleSignInWithKakaoAccount() {
                                  self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
                              }
                          }
                      }
                      self.openKakaoService()
                  } else { // 유효한 토큰
                      self.loadingInfoDidKakaoAuth()
                  }
              }
          } else { // 만료된 토큰
              self.openKakaoService()
          }
      }
      
      func handleSignInWithKakaoTalkApp() async -> Bool {
          await withCheckedContinuation { continuation in
              UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
                  if let error = error { // 로그인 실패 -> 종료
                      print("Kakao Sign In Error: ", error.localizedDescription)
                      continuation.resume(returning: false)
                  }
                  
                  _ = oauthToken // 로그인 성공
                  continuation.resume(returning: true)
                  self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
              }
          }
      }
      
      func handleSignInWithKakaoAccount() async -> Bool {
          await withCheckedContinuation { continuation in
              UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
                  if let error = error { // 로그인 실패 -> 종료
                      print("Kakao Sign In Error: ", error.localizedDescription)
                      continuation.resume(returning: false)
                  }
                  _ = oauthToken // 로그인 성공
                  continuation.resume(returning: true)
                  self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
              }
          }
      }
      
      func openKakaoService() {
          if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
              UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
                  if let error = error { // 로그인 실패 -> 종료
                      print("Kakao Sign In Error: ", error.localizedDescription)
                      return
                  }
                  
                  _ = oauthToken // 로그인 성공
                  self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
              }
          } else { // 카카오톡 앱 이용 불가능한 사람
              UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
                  if let error = error { // 로그인 실패 -> 종료
                      print("Kakao Sign In Error: ", error.localizedDescription)
                      return
                  }
                  _ = oauthToken // 로그인 성공
                  self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
              }
          }
      }
      
      func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
          UserApi.shared.me { kakaoUser, error in
              if let error = error {
                  print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                  
                  return
              }
              guard let email = kakaoUser?.kakaoAccount?.email else { return }
              guard let password = kakaoUser?.id else { return }
              guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
              let profileImageURL = kakaoUser?.kakaoAccount?.profile?.profileImageUrl?.absoluteString
              
              // 회원가입 한 후에, 이 데이터로 로그인까지 하는 것
              self.emailAuthSignUp(email: email, nickname: userName, password: "\(password)", profileImageURL: profileImageURL, appsToken: "카카오 토큰") {
                  self.emailAuthSignIn(email: email, password: "\(password)")
              }
          }
      }
      
  //    @MainActor
      func kakaoSignOut() {
          Task {
              if await handleKakaoSignOut() {
                  state = .signedOut
              }
          }
      }
      
      func handleKakaoSignOut() async -> Bool {  // 카카오 계정 로그아웃
          await withCheckedContinuation { continuation in
              UserApi.shared.logout {(error) in
                  if let error = error {
                      print(error)
                      continuation.resume(returning: false)
                  }
                  else {
                      print("logout() success.")
                      continuation.resume(returning: true)
                  }
              }
          }
          
      }
      
      // 유저정보를 firebase에 추가하기
      // 이 전에 이미지 받아서 파이어베이스 스토어에 넣고, 그 이미지의 url을 받아서 파베에 넣으면 됨
      // 닉네임 받아오고, 이미지 받아오고, 앱 토큰 받아오기
      
      // 카카오톡 / 구글 / 애플 분기해야 함
      
      func createUserFirebase(nickname: String, profileImageURL: String, appsToken: String) async {
          do {
              try firebaseManager.createData(
                  collectionName: "Users",
                  data: User(
                    id: UUID().uuidString,
                    nickname: nickname,
                    profileImageURL: profileImageURL,
                    apnsToken: appsToken,
                    createdDate: Date(),
                    likeGameId: nil,
                    likeShopId: nil,
                    myReviewsCount: 0,
                    myLikesCount: 0,
                    loginPlatform: .kakakotalk)
              )
          } catch {
              print("\(error)")
          }
          
      }
    
}
