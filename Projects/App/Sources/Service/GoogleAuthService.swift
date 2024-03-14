//
//  GoogleAuthService.swift
//  gambler
//
//  Created by 박성훈 on 3/4/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import GoogleSignIn

@MainActor
final class GoogleAuthSerVice {
    static let shared = GoogleAuthSerVice()
    
    typealias GoogleAuthResult = (GIDGoogleUser?, Error?) -> Void
    
    private init() { }
    
    /// Sign in with `Google`.
    /// - Parameter completion: restore/sign-in 흐름이 완료되면 호출되는 블록
    func signInWithGoogle(_ completion: @escaping GoogleAuthResult) async {
        // 1. 이전 로그인 확인
        if GIDSignIn.sharedInstance.hasPreviousSignIn() { // 이 전에 로그인 - 사용자의 로그인 복원
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                completion(user, error)
            }
        } else {  // 로그인 뷰로 이동
            // 2. UIApplication의 공유 인스턴스를 통해 루트 뷰 컨트롤러에 액세스
            // Google Sign-In SDK는 rootViewController를 사용하여 로그인 흐름을 호스팅하는 브라우저 팝업을 제공
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            // 3. Start sign-in flow
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                completion(result?.user, error)
            }
        }
    }
    
    /// Sign out from `Google`.
    func signOutFromGoogle() async {
        GIDSignIn.sharedInstance.signOut()
    }
}
