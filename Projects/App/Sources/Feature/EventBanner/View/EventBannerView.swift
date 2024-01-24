//
//  EventBannerView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct EventBannerView: View {
    var body: some View {
        NavigationLink {
            WebView(urlToLoad: "https://www.apple.com")
        } label: {
            Rectangle()
                .fill(Color.clear)
                .frame(width: .infinity, height: 150)
                .border(Color.black)
                .overlay(
                    Text("Event Banner")
                        .font(.largeTitle)
                )
        }
    }
}

#Preview {
    NavigationStack {
        EventBannerView()
    }
}
