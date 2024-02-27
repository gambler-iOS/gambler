//
//  KakaoMapView.swift
//  gambler
//
//  Created by daye on 1/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import KakaoMapsSDK
import CoreLocation

struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool
    @Binding var userLocate: GeoPoint
    @Binding var isShowingSheet: Bool
    @Binding var selectedShop: Shop
    @Binding var isLoading: Bool
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view: KMViewContainer = KMViewContainer()
        view.sizeToFit()
        context.coordinator.createController(view)
        context.coordinator.controller?.initEngine()
        return view
    }
    
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                context.coordinator.controller?.startEngine()
                context.coordinator.controller?.startRendering()}
        } else {
            context.coordinator.controller?.stopRendering()
            context.coordinator.controller?.stopEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(userLocate: $userLocate,
                                   isShowingSheet: $isShowingSheet, tappedShop: $selectedShop, isLoading: $isLoading)
    }
    
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        
    }
    
    final class KakaoMapCoordinator: NSObject, MapControllerDelegate, GuiEventDelegate, KakaoMapEventDelegate {
        @Binding var userLocate: GeoPoint
        @Binding var isShowingSheet: Bool
        @Binding var selectedShop: Shop
        @State private var isTappingPoi: Bool = false
        @Binding var isLoading: Bool
        
        var controller: KMController?
        let locationManager = CLLocationManager()
        var first: Bool
        var cameraStoppedHandler: DisposableEventHandler?
        var cameraStartHandler: DisposableEventHandler?
        var locationPoiID: String = ""
        var recentPoiId: String?
        
        init (userLocate: Binding<GeoPoint>, isShowingSheet: Binding<Bool>,
              tappedShop: Binding<Shop>, isLoading: Binding<Bool>) {
            first = true
            self._userLocate = userLocate
            self._isShowingSheet = isShowingSheet
            self._selectedShop = tappedShop
            self._isLoading = isLoading
            super.init()
        }
        
        func createController(_ view: KMViewContainer) {
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        func addViews() {
            let defaultPosition: MapPoint = MapPoint(longitude: userLocate.longitude, latitude: userLocate.latitude)
            let mapviewInfo: MapviewInfo =
            MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
            
            if controller?.addView(mapviewInfo) == Result.OK {
                settingMap()
                isLoading  = false
            }
        }
        
        func settingMap() {
            if let mapView = controller?.getView("mapview") as? KakaoMap {
                cameraStartHandler = mapView
                    .addCameraWillMovedEventHandler(target: self, handler: KakaoMapCoordinator.cameraWillMove)
                cameraStoppedHandler = mapView
                    .addCameraStoppedEventHandler(target: self, handler: KakaoMapCoordinator.onCameraStopped)
                getUserLocation()
                createLabelLayer()
                createPoiStyle()
                createUserLocationPoi()
                createPoisOnMap()
                createSpriteGUI()
            }
        }
        
        func cameraWillMove(_ param: CameraActionEventParam) {
            if param.by == .notUserAction {
                print("[Action: Camera will move]")
                cameraStartHandler?.dispose()
            }
        }
        
        func onCameraStopped(_ param: CameraActionEventParam) {
            if param.by == .notUserAction {
                cameraStoppedHandler?.dispose()
            }
        
        }
        
        func containerDidResized(_ size: CGSize) {
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
            if first {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                     let cameraUpdate: CameraUpdate = CameraUpdate
                        .make(target: MapPoint(longitude: self.userLocate.longitude, 
                                               latitude: self.userLocate.latitude),
                                                  zoomLevel: 15, mapView: mapView!)
                    mapView?.moveCamera(cameraUpdate)
                }
                first = false
            }
        }
    }
}
