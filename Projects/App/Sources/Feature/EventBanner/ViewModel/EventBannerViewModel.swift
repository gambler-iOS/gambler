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
    private let firebaseManager = FirebaseManager.shared
    
    init() {
//        generateDummyData()
    }

    private func generateDummyData() {
        eventBanners = EventBanner.dummyEventBannerList
    }
    
    @MainActor
    func fetchData() async {
        eventBanners.removeAll()
        do {
            eventBanners = try await firebaseManager
                .fetchAllData(collectionName: AppConstants.CollectionName.eventBanners)
        } catch {
            print("Error fetching EventBannerViewModel : \(error.localizedDescription)")
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
