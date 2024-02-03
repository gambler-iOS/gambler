//
//  EventBannerView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct EventBannerView: View {
    var eventBannerViewModel: EventBannerViewModel

    var body: some View {
        VStack {
            NavigationLink {
                WebView(urlToLoad: "https://www.apple.com")
            } label: {
                Rectangle()
                    .fill(Color.clear)
                    .border(Color.black)
                    .frame(width: 300, height: 150)
                    .overlay(
                        Text("Event Banner")
                            .font(.largeTitle)
                    )
            }
        }
    }
}

#Preview {
    NavigationStack {
        EventBannerView(eventBannerViewModel: EventBannerViewModel())
    }
}
