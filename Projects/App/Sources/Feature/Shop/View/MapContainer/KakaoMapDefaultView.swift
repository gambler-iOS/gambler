//
//  KakaoMapDefaultView.swift
//  gambler
//
//  Created by cha_nyeong on 3/6/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import KakaoMapsSDK
import CoreLocation

struct KakaoMapDefaultView: UIViewRepresentable {
    @Binding var shopLocate: GeoPoint
    @Binding var draw: Bool
    
    /// UIView를 상속한 KMViewContainer를 생성한다.
    /// 뷰 생성과 함께 KMControllerDelegate를 구현한 Coordinator를 생성하고, 엔진을 생성 및 초기화한다.
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view: KMViewContainer = KMViewContainer()
        view.sizeToFit()
        context.coordinator.createController(view)
        context.coordinator.controller?.initEngine()
        return view
    }
    
    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    /// draw가 true로 설정되면 엔진을 시작하고 렌더링을 시작한다.
    /// draw가 false로 설정되면 렌더링을 멈추고 엔진을 stop한다.
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                context.coordinator.controller?.startEngine()
                context.coordinator.controller?.startRendering()
            }
        } else {
            context.coordinator.controller?.stopRendering()
            context.coordinator.controller?.stopEngine()
        }
    }
    
    /// Coordinator 생성
    func makeCoordinator() -> KakaoMapDefaultCoordinator {
        return KakaoMapDefaultCoordinator(shopLocate: $shopLocate)
    }
    
    /// Cleans up the presented `UIView` (and coordinator) in
    /// anticipation of their removal.
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapDefaultCoordinator) {
        
    }
    
    /// Coordinator 구현. KMControllerDelegate를 adopt한다.
    final class KakaoMapDefaultCoordinator: NSObject, MapControllerDelegate {
        @Binding var shopLocate: GeoPoint
        let locationManager = CLLocationManager()
        var controller: KMController?
        var first: Bool
        
        init(shopLocate: Binding<GeoPoint>) {
            self._shopLocate = shopLocate
            first = true
            super.init()
        }
        
        // KMController 객체 생성 및 event delegate 지정
        func createController(_ view: KMViewContainer) {
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        // KMControllerDelegate Protocol method구현
        
        /// 엔진 생성 및 초기화 이후, 렌더링 준비가 완료되면 아래 addViews를 호출한다.
        /// 원하는 뷰를 생성한다.
        func addViews() {
            let defaultPosition: MapPoint = MapPoint(longitude: shopLocate.longitude, latitude: shopLocate.latitude)
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "shopmapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
            
            controller?.addView(mapviewInfo)
        }
        
        //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            settingMap()
            print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
        }
        
        //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
        func addViewFailed(_ viewName: String, viewInfoName: String) {
            print("Failed")
        }
        
        func settingMap() {
            createLabelLayer()
            createPoiStyle()
            createPoisOnMap()
        }
        
        /// KMViewContainer 리사이징 될 때 호출.
        func containerDidResized(_ size: CGSize) {
            if let mapView = controller?.getView("shopmapview") as? KakaoMap {
                mapView.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
                if first {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let cameraUpdate: CameraUpdate = CameraUpdate
                            .make(target: MapPoint(longitude: self.shopLocate.longitude,
                                                   latitude: self.shopLocate.latitude),
                                  zoomLevel: 16, mapView: mapView)
                        mapView.moveCamera(cameraUpdate)
                    }
                    first = false
                }
            }
        }
        
        func createPoisOnMap() {
            if let mapView = controller?.getView("shopmapview") as? KakaoMap {
                let manager = mapView.getLabelManager()
                let layer = manager.getLabelLayer(layerID: "PoiLayer")
                let poiOption = PoiOptions(styleID: "shopPoiIconStyle")
                poiOption.rank = 0
                poiOption.transformType = .decal
                poiOption.clickable = false
                
                let markerPoint = MapPoint(longitude: Double(shopLocate.longitude),
                                           latitude: shopLocate.latitude)
                let marker = layer?.addPoi(option: poiOption, at: markerPoint)
                marker?.show()
            }
        }
        
        func createPoiStyle() {
            if let mapView = controller?.getView("shopmapview") as? KakaoMap {
                let manager = mapView.getLabelManager()
                let shopPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "markPressed")?
                    .resized(withSize: CGSize(width: 49, height: 69)))
                let shopPoiStyle = PoiStyle(styleID: "shopPoiIconStyle", styles: [
                    PerLevelPoiStyle(iconStyle: shopPoiIconStyle, level: 1)
                ])
                manager.addPoiStyle(shopPoiStyle)
            }
        }
        
        
        func createLabelLayer() {
            if let mapView = controller?.getView("shopmapview") as? KakaoMap {
                let manager = mapView.getLabelManager()
                
                let markerLayerOption = LabelLayerOptions(layerID: "PoiLayer"
                                                          ,competitionType: .none,
                                                          competitionUnit: .symbolFirst,
                                                          orderType: .rank, zOrder: 5000)
                _ = manager.addLabelLayer(option: markerLayerOption)
                
            }
        }
    }
}
