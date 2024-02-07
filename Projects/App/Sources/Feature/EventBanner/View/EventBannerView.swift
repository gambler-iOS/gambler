//
//  EventBannerView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct EventBannerView: View {
    @ObservedObject var eventBannerViewModel: EventBannerViewModel
    private var banners: [EventBanner] {
        eventBannerViewModel.eventBanners
    }

    var body: some View {
        VStack {
            if let url = URL(string: banners[eventBannerViewModel.currentIndex].bannerImage) {
                NavigationLink {
                    WebView(urlToLoad: banners[eventBannerViewModel.currentIndex].linkURL)
                } label: {
                    ZStack {
                        KFImage(url)
                            .resizable()
                            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 400, maxHeight: 400)
                            .scaledToFit()
                        GeometryReader(content: { geometry in
                            Image(systemName: "bell.fill")
                                .foregroundStyle(.white)
                                .position(x: geometry.size.width - 20, y: 80)
                                .onTapGesture {
                                    print("tab")
                                }
                            Text("Gambler")
                                .foregroundStyle(.white)
                                .bold()
                                .position(x: 50, y: 80)
                            HStack {
                                ForEach(Array(0 ..< banners.count), id: \.self) { index in
                                    Circle()
                                        .fill(self.eventBannerViewModel.currentIndex == index ? Color.red : Color.white)
                                        .frame(width: 10, height: 10)
                                }
                            }
                            .position(x: 50, y: 370)
                        })
                    }
                    .frame(maxWidth: .infinity, maxHeight: 400)
                }
            }
        }
        .onAppear {
            print("apear")
            eventBannerViewModel.startTimer()
        }
        .onDisappear {
            print("disapear")
            eventBannerViewModel.stopTimer()
        }
    }
}

#Preview {
    NavigationStack {
        EventBannerView(eventBannerViewModel: EventBannerViewModel())
    }
}
