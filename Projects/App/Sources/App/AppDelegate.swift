//
//  AppDelegate.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/18/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
