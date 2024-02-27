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
    
    @State private var draw: Bool = false
    @State private var userLocate: GeoPoint = GeoPoint(latitude: 37.402001, longitude: 127.108678)
    @State private var isShowingSheet: Bool = false
    @State private var detent: PresentationDetent = .medium
    @State private var selectedShop: Shop = Shop.dummyShop
    @StateObject var shopStore = ShopStore()
    
    var body: some View {
        KakaoMapView(draw: $draw, userLocate: $userLocate,
                     isShowingSheet: $isShowingSheet, selectedShop: $selectedShop)
            .onAppear {
                self.draw = true
            }
            .onDisappear(perform: {
                self.draw = false
            })
            .overlay {
                Group {
                    FloatingView(shopStore: shopStore, selectedShop: $selectedShop, 
                                 isShowingSheet: $isShowingSheet, userLocate: $userLocate)
                        .frame(width: 327, height: 182)
                        .offset(y: 250)
                }
            }
            .fullScreenCover(isPresented: $isShowingSheet) {
                MapSheetView(shopStore: shopStore)
                    .overlay {
                        showMapButton
                            .offset(y: UIScreen.main.bounds.height/3)
                    }
            }
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
    KakaoMapView(draw: .constant(true), userLocate: .constant(GeoPoint(latitude: 13.0000, longitude: 13.0000)),
                 isShowingSheet: .constant(false), selectedShop: .constant(Shop.dummyShop))
}
