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
    @State private var userLocate: GeoPoint = GeoPoint.defaultPoint
    @State private var isShowingSheet: Bool = false
    @State private var isLoading: Bool = true
    @State private var detent: PresentationDetent = .medium
    @State private var selectedShop: Shop = Shop.dummyShop
    @StateObject var shopStore = ShopStore()
    
    var body: some View {
        KakaoMapView(draw: $draw, userLocate: $userLocate,
                     isShowingSheet: $isShowingSheet, selectedShop: $selectedShop, isLoading: $isLoading)
            .onAppear {
                self.draw = true
            }
            .onDisappear(perform: {
                self.draw = false
                isLoading = false
            })
            .overlay {
                Group {
                    if isLoading {
                        ProgressView()
                            .offset(y: 0)
                    } else {
                        FloatingView(shopStore: shopStore, selectedShop: $selectedShop,
                                     isShowingSheet: $isShowingSheet, userLocate: $userLocate)
                        .frame(width: 327, height: 182)
                        .offset(y: 250)
                    }
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
    KakaoMapView(draw: .constant(true), userLocate: .constant(GeoPoint.defaultPoint),
                 isShowingSheet: .constant(false), selectedShop: .constant(Shop.dummyShop), isLoading: .constant(true))
}
