//
//  GamblerApp.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/1/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import CoreLocation
import SwiftData

@main
struct GamblerApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SearchKeyword.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .onAppear {
                    Task {
                        await startTask()
                    }
                }
//            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    func startTask() async {
        let locationManager = CLLocationManager()
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .denied {
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        else if authorizationStatus == .restricted || authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("테스트")
            .font(.head1B)
        Text("테스트")
        Text("테스트")
            .font(.head1B)
            .foregroundStyle(Color.primaryDefault)
        GamblerAsset.bell.swiftUIImage
            .renderingMode(.template) // 렌더링 모드 설정 시 색상 변경 가능
            .foregroundStyle(Color.gray300)
    }
}

#Preview {
    ContentView()
}
