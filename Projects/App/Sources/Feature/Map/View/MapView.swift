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

    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @StateObject private var mapViewModel = MapViewModel()
    
    @State private var selectedShop: Shop = Shop.dummyShop
    @State private var userLocate: GeoPoint = GeoPoint.defaultPoint
    @State private var isLoading: Bool = true
    @State private var isShowingSheet: Bool = false
    
    @Binding var draw: Bool
    
    var body: some View {
        NavigationStack(path: $appNavigationPath.mapViewPath) {
            KakaoMapView(mapViewModel: mapViewModel,
                         userLocate: $userLocate,
                         selectedShop: $selectedShop,
                         draw: $draw,
                         isShowingSheet: $isShowingSheet,
                         isLoading: $isLoading)
            .overlay {
                if !isShowingSheet && !isLoading {
                    FloatingView(mapViewModel: mapViewModel, 
                                 selectedShop: $selectedShop,
                                 isShowingSheet: $isShowingSheet, 
                                 userLocate: $userLocate)
                    .frame(width: 327, height: 182)
                    .offset(y: 250)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(.gray400)
                        .offset(y: 0)
                }
                if isShowingSheet {
                    MapSheetView(mapViewModel: mapViewModel, userLocate: $userLocate)
                        .opacity(isShowingSheet ? 1 : 0)
                        .transition(.move(edge: .bottom))
                        .offset(y: getSafeAreaTop())
                        .overlay {
                            showMapButton
                                .offset(y: 300)
                        }
                }
            }
            .overlay(safetyAreaTopScreen, alignment: .top)
            .task {
                if selectedShop == Shop.dummyShop {
                    if let newShop = await mapViewModel.fetchOneShop() {
                        selectedShop = newShop
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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
    
    private var safetyAreaTopScreen: some View {
        Group {
            Rectangle()
                .frame(height: getSafeAreaTop() + 20)
                .edgesIgnoringSafeArea(.top)
                .foregroundColor(.white)
                .opacity(isShowingSheet ? 1 : 0)
        }
    }
}

#Preview {
    NavigationStack {
        KakaoMapView(mapViewModel: MapViewModel(),
                     userLocate: .constant(GeoPoint.defaultPoint),
                     selectedShop: .constant(Shop.dummyShop),
                     draw: .constant(true), 
                     isShowingSheet: .constant(false),
                     isLoading: .constant(false))
    }
}
