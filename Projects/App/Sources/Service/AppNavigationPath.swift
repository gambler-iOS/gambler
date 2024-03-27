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
    @Published var loginViewPath = NavigationPath()
}
