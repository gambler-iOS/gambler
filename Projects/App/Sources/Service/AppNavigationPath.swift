//
//  AppNavigationPath.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

final class AppNavigationPath: ObservableObject {
    @Published var homeViewPath = NavigationPath()
    
}


final class NavigationPathFinder: ObservableObject {
    static let shared = NavigationPathFinder()
    private init() { }
    
    @Published var loginViewPath = NavigationPath()
    
    func addPath(option: LoginViewOptions) {
        loginViewPath.append(option)
    }
    
    func popToRoot() {
        loginViewPath = .init()
    }
}

enum LoginViewOptions: Hashable {
    case loginView
    case regstrationView
    case temsOfAgreeView
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .loginView: 
            LoginView()  // 넘길 연관값이 없음 - 있다면 User 정보?? - 필요하면 수정하자
        case .regstrationView:
            RegistrationView()
        case .temsOfAgreeView: 
            RegisterTermsOfUseView()
        }
    }
}
