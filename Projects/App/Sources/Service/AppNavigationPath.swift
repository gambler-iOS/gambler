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
    @Published var registViewIsActive: Bool = false
    @Published var registTermsViewIsActive: Bool = false
    
    func returnToPreLogin() {
        isGoTologin = false
        registViewIsActive = false
        registTermsViewIsActive = false
    }
}
