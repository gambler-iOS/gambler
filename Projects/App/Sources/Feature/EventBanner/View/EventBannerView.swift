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
    private let bannerImageHeight: CGFloat = 400
    
    private var banners: [EventBanner] {
        eventBannerViewModel.eventBanners
    }

    var body: some View {
        GeometryReader { geometry in
            let offset = geometry.frame(in: .global).minY
            VStack(spacing: .zero) {
                if banners.isEmpty {
                    EmptyView()
                } else {
                    if let url = URL(string: banners[eventBannerViewModel.currentIndex].bannerImage) {
                        NavigationLink {
                            EventBannerWebView(urlToLoad: banners[eventBannerViewModel.currentIndex].linkURL)
                        } label: {
                            VStack(spacing: .zero) {
                                KFImage(url)
                                    .resizable()
                                    .frame(width: geometry.size.width + (offset > 0 ? offset : 0),
                                           height: bannerImageHeight  + (offset > 0 ? offset : 0))
                                    .scaledToFit()
                                    .overlay {
                                        Color.black
                                            .opacity(0.6)
                                    }
                                    .overlay(alignment: .bottomLeading) {
                                        VStack(alignment: .leading, spacing: 32) {
                                            Text("\(banners[eventBannerViewModel.currentIndex].catchphrase)")
                                                .multilineTextAlignment(.leading)
                                                .font(.head1B)
                                                .foregroundStyle(Color.gray50)
                                                .lineLimit(2)
                                                .truncationMode(.tail)
                                                .frame(width: geometry.size.width - 48, alignment: .leading)
                                            
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
                                        .padding(.leading, 24)
                                        .offset(x: (offset > 0 ? offset / 2 : 0))
                                    }
                            }
                            .offset(x: (offset > 0 ? -offset / 2 : 0), y: (offset > 0 ? -offset : 0))
                            .onAppear {
                                eventBannerViewModel.startTimer()
                            }
                            .onDisappear {
                                eventBannerViewModel.stopTimer()
                            }
                        }
                    }
                }
            }
        }
        .frame(minHeight: bannerImageHeight)
    }
}

#Preview {
    NavigationStack {
        EventBannerView(eventBannerViewModel: EventBannerViewModel())
    }
}
