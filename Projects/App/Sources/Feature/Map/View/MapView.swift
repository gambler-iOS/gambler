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
                self.draw = true
            }
            .onDisappear(perform: {
                self.draw = false
            })
            .overlay {
                Group {
                    if isShowingSheet {
                        FloatingView(shop: Shop.dummyShop, isShowingSheet: $isShowingSheet)
                            .frame(width: 327, height: 182)
                            .offset(y: 250)
                        
                        
                    }
                }
            }
        /*
            .fullScreenCover(isPresented: $isShowingSheet) {
                MapSheetView()
                    .overlay {
                        showMapButton
                            .offset(y: 250)
                    }
            }*/
    
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var showMapButton: some View {
            GamblerAsset.showMap.swiftUIImage
                .resizable()
                .frame(width: 97, height: 44)
                .onTapGesture {
                    withAnimation {
                        isShowingSheet = false
                    }
                }
        }
    
}

#Preview {
    KakaoMapView(draw: .constant(true), userLatitude: .constant(13.0000), userLongitude: .constant(13.0000), isShowingSheet: .constant(false), isMainMap: true)
}
