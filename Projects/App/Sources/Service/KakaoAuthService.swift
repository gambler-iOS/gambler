//
//  KakaoService.swift
//  gambler
//
//  Created by 박성훈 on 3/5/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth

@MainActor
final class KakaoAuthService {
    static let shared = KakaoAuthService()
    
    private let kakao = UserApi.shared
    
    var createKakaoAccount: Bool = false
    
    typealias KakaoAuthResult = (KakaoSDKUser.User?, Bool)  // 유저정보, 토큰활성여부(Bool)
    
    private init() { }
    
    // 사용자에게 카카오 로그인을 요청 / 사용자는 카카오 로그인 완료
    func signInWithKakao() async {
        // 카카오 토큰이 존재한다면
        if AuthApi.hasToken() {
            kakao.accessTokenInfo { _, error in
                if let error {
                    print("DEBUG: 카카오톡 토큰 가져오기 에러 \(error.localizedDescription)")
                    self.kakaoLogin()
                } else {
                    // 토큰 유효성 체크 성공 (필요 시 토큰 생신됨)
                    self.kakaoTalkloginInFirebase()
                }
            }
        } else {
            // 토큰이 없는 상태 로그인 필요
            self.kakaoLogin()
        }
    }
    
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginInApp() // 카카오톡 앱이 있다면 앱으로 로그인
        } else {
            kakaoLoginInWeb() // 앱이 없다면 웹으로 로그인 (시뮬레이터)
        }
    }
    
    // - 카카오 인증 서버에 사용자 정보를 가져오기 위해 토큰 발급을 요청합니다.
    // - 토큰을 발급 받으면 토큰과 함께 사용자 정보를 요청합니다. (이메일, userID)
    // - 토큰 검증 완료 후 사용자 정보를 제공받습니다.
    private func kakaoLoginInApp() {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.kakaoTalkloginInFirebase()
                }
            }
        }
    }
    
    private func kakaoLoginInWeb() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print("DEBUG: 카카오톡 로그인 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 로그인 Success")
                if let token = oauthToken {
                    print("DEBUG: 카카오톡 토큰 \(token)")
                    self.kakaoTalkloginInFirebase()
                }
            }
        }
    }
    
    // 파이어베이스 인증 서버에 이메일/userID로 회원가입 및 로그인을 완료합니다.
    // 로그인 여부를 확인합니다.
    private func kakaoTalkloginInFirebase() {
        UserApi.shared.me() { user, error in
            if let error = error {
                print("DEBUG: 카카오톡 사용자 정보가져오기 에러 \(error.localizedDescription)")
            } else {
                print("DEBUG: 카카오톡 사용자 정보가져오기 success.")
                
                guard let email = user?.kakaoAccount?.email else { return }
                guard let name = user?.kakaoAccount?.profile?.nickname else { return }
                guard let profileImageURL = user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString else { return }
                let password: String = String(describing: user?.id)
                
                // 파이어베이스 유저 생성 (이메일로 회원가입)
                Task {
                    await self.loginKakaoTalk(email: email,
                                                            password: password,
                                                            name: name,
                                                            profileImageURL: profileImageURL)
                }
            }
        }
    }
    
    @MainActor
    private func loginKakaoTalk(email: String, password: String, name: String, profileImageURL: String) async {
        Task {
            if await AuthService.shared.loginWithEmail(email: email, password: password, name: name, profileImageURL: profileImageURL) {
                // 로그인 성공
                print(#fileID, #function, #line, "- email 로그인 성공 ~~~ ")
            } else {
                // 로그인 실패 - 회원가입 해야함
                print("createUser 실행")
                await AuthService.shared.createUser(email: email, password: password, name: name, profileImageURL: profileImageURL)
            }
        }
    }
    
    func handleKakaoLogout() async {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
        }
    }
    
    func unlinkKakao() async {
        UserApi.shared.unlink { (error) in
            if let error = error {
                print(error)
            } else {
                print("unlink() success.")
            }
        }
    }
    
    func deleteKakaoAccount() async {
        if await AuthService.shared.deleteAuth() {
            await KakaoAuthService.shared.unlinkKakao()
            print("카카오 계정 지우기 성공!")
        } else {
        }
    }
    
}
