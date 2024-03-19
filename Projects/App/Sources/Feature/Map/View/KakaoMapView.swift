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
    @Binding var userLocate: GeoPoint
    @Binding var selectedShop: Shop
    @Binding var draw: Bool
    @Binding var isShowingSheet: Bool
    @Binding var isLoading: Bool
    @ObservedObject var shopStore: ShopStore
    
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
                                   isShowingSheet: $isShowingSheet,
                                   tappedShop: $selectedShop,
                                   isLoading: $isLoading,
                                   shopStore: _shopStore)
    }
    
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        
    }
    
    final class KakaoMapCoordinator: NSObject, MapControllerDelegate, GuiEventDelegate, KakaoMapEventDelegate {
        @Binding var userLocate: GeoPoint
        @Binding var selectedShop: Shop
        @Binding var isShowingSheet: Bool
        @Binding var isLoading: Bool
        @ObservedObject var shopStore: ShopStore
        
        let locationManager = CLLocationManager()
        var controller: KMController?
        var first: Bool
        var cameraStoppedHandler: DisposableEventHandler?
        var cameraStartHandler: DisposableEventHandler?
        var locationPoiID: String = ""
        var recentPoiId: String?
        var tapPoiId: String = ""
        var firstTap: Bool = true
        
        init (userLocate: Binding<GeoPoint>, isShowingSheet: Binding<Bool>,
              tappedShop: Binding<Shop>, isLoading: Binding<Bool>, shopStore: ObservedObject<ShopStore>) {
            first = true
            self._userLocate = userLocate
            self._isShowingSheet = isShowingSheet
            self._selectedShop = tappedShop
            self._isLoading = isLoading
            self._shopStore = shopStore
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
            controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            settingMap()
            isLoading  = false
        }
        
        func settingMap() {
            if let mapView = controller?.getView("mapview") as? KakaoMap {
                mapView.setMargins(UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.main.bounds.height * 0.2 , right: 0))
                mapView.setLogoPosition(
                    origin: GuiAlignment(vAlign: .bottom, hAlign: .right),
                    position: CGPoint(x: 10.0, y: -UIScreen.main.bounds.height * 0.2 + 20))
                getUserLocation()
                createLabelLayer()
                createPoiStyle()
                createUserLocationPoi()
                createPoisOnMap()
                createSpriteGUI()
                moveCameraToFocus(MapPoint(longitude: userLocate.longitude,  latitude: userLocate.latitude))
                cameraStartHandler = mapView
                    .addCameraWillMovedEventHandler(target: self, handler: KakaoMapCoordinator.cameraWillMove)
                cameraStoppedHandler = mapView
                    .addCameraStoppedEventHandler(target: self, handler: KakaoMapCoordinator.onCameraStopped)
                Task {
                    let m = mapView.getPosition(CGPoint(x: mapView.viewRect.width * 0.5, y: mapView.viewRect.height * 0.5))
                    print(m.wgsCoord.latitude)
                    print(m.wgsCoord.longitude)
                    await shopStore.fetchMap(position: GeoPoint(latitude: m.wgsCoord.latitude, longitude: m.wgsCoord.longitude))
                }
            }
        }
        
        func cameraWillMove(_ param: CameraActionEventParam) {
            print("이건 됩니까..?")
            if param.by == .notUserAction {
                print("[Action: Camera will move]")
                cameraStartHandler?.dispose()
            }
        }
        
        func onCameraStopped(_ param: CameraActionEventParam) {
            print("되냐. ")
            if let mapView = controller?.getView("mapview") as? KakaoMap {
                Task {
                    let m = mapView.getPosition(CGPoint(x: mapView.viewRect.width * 0.5, y: mapView.viewRect.height * 0.5))
                    print(m.wgsCoord.latitude)
                    print(m.wgsCoord.longitude)
                    await shopStore.fetchMap(position: GeoPoint(latitude: m.wgsCoord.latitude, longitude: m.wgsCoord.longitude))
                    print(shopStore.shopList)
                    createPoisOnMap()
                }
            }
           /* if param.by == .notUserAction {
                cameraStoppedHandler?.dispose()
            }*/
        }
        
        func containerDidResized(_ size: CGSize) {
            if let mapView = controller?.getView("mapview") as? KakaoMap {
                mapView.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
                if first {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let cameraUpdate: CameraUpdate = CameraUpdate
                            .make(target: MapPoint(longitude: self.userLocate.longitude,
                                                   latitude: self.userLocate.latitude),
                                  zoomLevel: 15, mapView: mapView)
                        mapView.moveCamera(cameraUpdate)
                    }
                    first = false
                }
            }
        }
    }
}
