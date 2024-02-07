//
//  MapView.swift
//  gambler
//
//  Created by daye on 1/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import UIKit
import KakaoMapsSDK
import CoreLocation

struct MapView: View {
    @State var draw: Bool = false
    @State private var userLatitude: Double = 37.402001
    @State private var userLongitude: Double = 127.108678
    @State var isShowingSheet: Bool = false
    @State var detent: PresentationDetent = .medium
    
    var body: some View {
        KakaoMapView(draw: $draw, userLatitude: $userLatitude, userLongitude: $userLongitude, isShowingSheet: $isShowingSheet)
            .onAppear {
                Task {
                    await startTask()
                    self.draw = true
                }
            }
        
        /*.onDisappear(perform: {
         self.draw = false
         })*/
            .edgesIgnoringSafeArea(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $isShowingSheet) {
                NavigationView {
                    ShopListView(isShowingSheet: $isShowingSheet)
                }.presentationDetents([
                    .medium,
                    .large
                ], selection : $detent)
            }
    }
    
    func startTask() async {
        let locationManager = CLLocationManager()
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .denied {
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        else if authorizationStatus == .restricted || authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    KakaoMapView(draw: .constant(true), userLatitude: .constant(13.0000), userLongitude: .constant(13.0000), isShowingSheet: .constant(false))
}
