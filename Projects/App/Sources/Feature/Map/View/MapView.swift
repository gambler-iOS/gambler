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
    @State var draw: Bool = true
    @State private var userLatitude: Double = 37.402001
    @State private var userLongitude: Double = 127.108678
    @State var isShowingSheet: Bool = false
    
    var body: some View {
        KakaoMapView(draw: $draw, userLatitude: $userLatitude, userLongitude: $userLongitude, isShowingSheet: $isShowingSheet)
            .onAppear {
                Task {
                    await startTask()
                    self.draw = true
                }
            }
            .onDisappear(perform: {
                self.draw = false
            })
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $isShowingSheet) {
                ShopListView()
            }
            
    }
    
    func startTask() async {
           // 위치 사용 권한 설정 확인
           let locationManager = CLLocationManager()
           let authorizationStatus = locationManager.authorizationStatus
          // 위치 사용 권한 항상 허용되어 있음
           if authorizationStatus == .authorizedAlways {}
        //위치 사용 권한 앱 사용 시 허용되어 있음
           else if authorizationStatus == .authorizedWhenInUse {}
           // 위치 사용 권한 거부되어 있음
           if authorizationStatus == .denied {
               // 앱 설정화면으로 이동 - 필요한지 고려해보기
               DispatchQueue.main.async {
                   UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
               }
           }
           // 위치 사용 권한 대기 상태
           else if authorizationStatus == .restricted || authorizationStatus == .notDetermined {
               // 권한 요청 팝업창
               locationManager.requestWhenInUseAuthorization()
           }
       }
}
