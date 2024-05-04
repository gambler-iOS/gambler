//
//  AppDelegate.swift
//  gambler
//
//  Created by 박성훈 on 3/5/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
