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
    @Published var searchViewPath = NavigationPath()
    @Published var mapViewPath = NavigationPath()
    @Published var myPageViewPath = NavigationPath()
    
    /// 로그인 필요할 때 LoginView 이동 navigationDestination 용 flag
    @Published var isGoTologin: Bool = false
}

enum LoginViewOptions: Hashable {
    case loginView
    case regstrationView
    case temsOfAgreeView
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .loginView:
            LoginView()
        case .regstrationView:
            RegistrationView()
        case .temsOfAgreeView:
            RegisterTermsOfUseView()
        }
    }
}
