//
//  EventBannerViewModel.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

class EventBannerViewModel: ObservableObject {
    @Published var eventBanners: [EventBanner] = []

    private let firebaseManager = FirebaseManager.shared

    @MainActor
    func fetchData() async {
        eventBanners = await firebaseManager.fetchAllData(collectionName: "EventBanners", objectType: EventBanner.self)
    }
}
