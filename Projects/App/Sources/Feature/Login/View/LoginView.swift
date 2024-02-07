//
//  MainView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 12/31/23.
//  Copyright © 2023 gambler. All rights reserved.
//

import SwiftUI
import FirebaseAuth


struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
//    @State private var signInProcessing: Bool = false
//    let signInStatusInfo: (Bool) -> String = { isSignIn in
//        return isSignIn ? "로그인 상태" : "로그아웃 상태"
//    }
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                
            } label: {
                Text("애플 로그인")
            }
            
            Button {
//                signInProcessing = true
                loginViewModel.kakaoAuthSignIn()
            } label: {
                Text("카카오톡 로그인")
            }
            
            Button {
                
            } label: {
                Text("구글 로그인")
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    MainView()
}
