//
//  EventBanner.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct EventBanner: AvailableFirebase {
    var id: String
    let bannerImage: String
    let linkURL: String
    let catchphrase: String
}

extension EventBanner {
    static let dummyEventBannerList: [EventBanner] = [
        EventBanner(id: UUID().uuidString,
                    bannerImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20200816_204%2F159751769979164CGG_JPEG%2FJv7Iy_VyoeWmWNfHBvTu2nux.jpg",
                    linkURL: "https://www.apple.com",
                    catchphrase: "신규 게임을\n빠르게 만나보세요"),
        EventBanner(id: UUID().uuidString,
                    bannerImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20221205_143%2F1670246625104fRRTg_JPEG%2F8B5186A8-F1C7-4824-AE91-EEDA059F496C.jpeg",
                    linkURL: "https://www.naver.com",
                    catchphrase: "신규 게임을\n빠르게 만나보세요"),
        EventBanner(id: UUID().uuidString,
                    bannerImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20171201_108%2F1512073471785j1m5s_JPEG%2F201605__DSC0645.jpg",
                    linkURL: "https://www.google.com",
                    catchphrase: "신규 게임을\n빠르게 만나보세요"),
    ]
}
