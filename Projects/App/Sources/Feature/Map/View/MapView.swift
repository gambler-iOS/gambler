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
        KakaoMapView(draw: $draw, userLatitude: $userLatitude, userLongitude: $userLongitude, isShowingSheet: $isShowingSheet, isMainMap: true)
            .onAppear {
                Task {
                    await startTask()
                    self.draw = true
                }
            }
            .overlay{
                Group {
                        if isShowingSheet {
                            FlotingView()
                                .offset(y: 250)
                        }
                }
            }
        
        /*.onDisappear(perform: {
         self.draw = false
         })*/
            .edgesIgnoringSafeArea(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    private struct FlotingView: View {
        var body: some View{
            HStack{
                Text("FlotingView")
            }.frame(width: 327, height: 132)
                .background(Color.white)
                .cornerRadius(16)
        }
    }
    
}

#Preview {
    KakaoMapView(draw: .constant(true), userLatitude: .constant(13.0000), userLongitude: .constant(13.0000), isShowingSheet: .constant(false), isMainMap: true)
}
