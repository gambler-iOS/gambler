//
//  EventBannerViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/20/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class EventBannerViewModel: ObservableObject {
    @Published var eventBanners: [EventBanner] = []
    @Published var currentIndex = 0
    private var timer: Timer?

    init() {
        generateDummyData()
    }

    func generateDummyData() {
        let testUrl: [String] = ["https://www.apple.com", "https://www.naver.com", "https://www.google.com"]
        let bannerImageUrl: [String] = [
            "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20200816_204%2F159751769979164CGG_JPEG%2FJv7Iy_VyoeWmWNfHBvTu2nux.jpg",
            "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20221205_143%2F1670246625104fRRTg_JPEG%2F8B5186A8-F1C7-4824-AE91-EEDA059F496C.jpeg",
            "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg"
        ]
        for index in 0...2 {
            eventBanners.append(
                EventBanner(id: UUID().uuidString,
                            bannerImage: bannerImageUrl[index],
                            linkURL: testUrl[index]))
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            if self.currentIndex + 1 == self.eventBanners.count {
                self.currentIndex = 0
            } else {
                self.currentIndex += 1
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
