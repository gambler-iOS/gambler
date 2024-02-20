//
//  EventBannerView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/20/24.
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
        VStack(spacing: .zero) {
            if let url = URL(string: banners[eventBannerViewModel.currentIndex].bannerImage) {
                NavigationLink {
                    // WebView(urlToLoad: banners[eventBannerViewModel.currentIndex].linkURL)
                    Text("WebView")
                } label: {
                    VStack(spacing: .zero) {
                        KFImage(url)
                            .resizable()
                            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 400, maxHeight: 400)
                            .scaledToFit()
                            .overlay(alignment: .bottomLeading) {
                                VStack(alignment: .leading, spacing: 32) {
                                    Text("신규 게임을\n빠르게 만나보세요")
                                        .multilineTextAlignment(.leading)
                                        .font(.head1B)
                                        .foregroundStyle(Color.gray50)
                                    
                                    HStack(spacing: 8) {
                                        ForEach(Array(0 ..< banners.count), id: \.self) { index in
                                            Circle()
                                                .fill(self.eventBannerViewModel.currentIndex == index ?
                                                      Color.primaryDefault : Color.white)
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                }
                                .padding(.bottom, 40)
                                .padding(.leading, 25)
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 400)
                }
            }
        }
        .onAppear {
            eventBannerViewModel.startTimer()
        }
        .onDisappear {
            eventBannerViewModel.stopTimer()
        }
    }
}

#Preview {
    NavigationStack {
        EventBannerView(eventBannerViewModel: EventBannerViewModel())
    }
}
