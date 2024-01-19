//
//  GamblerApp.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/1/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

@main
struct GamblerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
