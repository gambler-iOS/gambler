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
    var body: some Scene {
        WindowGroup {
            TabBarView()
//            MainView()
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
