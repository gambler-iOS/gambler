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
    @StateObject private var shopStore = ShopStore()
    @State private var draw: Bool = false
    @State private var isLoading: Bool = true
    @State private var isShowingSheet: Bool = false
    @State private var selectedShop: Shop = Shop.dummyShop
    @State private var userLocate: GeoPoint = GeoPoint.defaultPoint
    
    var body: some View {
        KakaoMapView(userLocate: $userLocate, selectedShop: $selectedShop,
                     draw: $draw, isShowingSheet: $isShowingSheet, isLoading: $isLoading)
            .onAppear {
                self.draw = true
            }
            .onDisappear(perform: {
               //self.draw = false
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
            .frame(width: 97, height: 48)
            .onTapGesture {
                withAnimation {
                    isShowingSheet = false
                }
            }
    }
}

#Preview {
    KakaoMapView(userLocate: .constant(GeoPoint.defaultPoint), selectedShop: .constant(Shop.dummyShop),
                 draw: .constant(true), isShowingSheet: .constant(false), isLoading: .constant(false))
}
