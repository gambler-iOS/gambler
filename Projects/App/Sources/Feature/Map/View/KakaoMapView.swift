//
//  KakaoMapView.swift
//  gambler
//
//  Created by daye on 1/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import UIKit
import KakaoMapsSDK
import CoreLocation

struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool
    @Binding var userLatitude: Double
    @Binding var userLongitude: Double
    @Binding var isShowingSheet: Bool
    var isMainMap: Bool

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
        }else {
            context.coordinator.controller?.stopRendering()
            // context.coordinator.controller?.stopEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(userLatitude: $userLatitude, userLongitude: $userLongitude, isShowingSheet: $isShowingSheet)
    }

    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {

    }
    
    // MARK: - 맵
    class KakaoMapCoordinator: NSObject, MapControllerDelegate, GuiEventDelegate, KakaoMapEventDelegate {
        private let locationManager = CLLocationManager()
        @Binding var userLatitude: Double
        @Binding var userLongitude: Double
        @Binding var isShowingSheet: Bool
        
        var controller: KMController?
        var first: Bool
        var markerTestDataManager = MarkerTestDataManager()
        var cameraStoppedHandler: DisposableEventHandler?
        var cameraStartHandler: DisposableEventHandler?
        var locationPoiID: String = ""
        var recentPoiId: String?

        init(userLatitude: Binding<Double>, userLongitude: Binding<Double>, isShowingSheet: Binding<Bool>) {
            first = true
            self._userLatitude = userLatitude
            self._userLongitude = userLongitude
            self._isShowingSheet = isShowingSheet
            super.init()
        }
    
        func createController(_ view: KMViewContainer) {
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        func addViews() {
            let defaultPosition: MapPoint = MapPoint(longitude: userLongitude, latitude: userLatitude)
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
            
            if controller?.addView(mapviewInfo) == Result.OK {
                if let mapView = controller?.getView("mapview") as? KakaoMap {
                    cameraStartHandler = mapView
                        .addCameraWillMovedEventHandler(target: self, handler: KakaoMapCoordinator.cameraWillMove)
                    cameraStoppedHandler = mapView
                        .addCameraStoppedEventHandler(target: self, handler: KakaoMapCoordinator.onCameraStopped)
                    getUserLocation()
                    createLabelLayer()
                    createPoiStyle()
                    createPoisOnMap()
                    createSpriteGUI()
                    
                } else {
                    print("[Error: KakaoMap casting failure]")
                }
            }
        }
        
        func cameraWillMove(_ param: CameraActionEventParam) {
            if (param.by == .notUserAction) {
                print("[Action: Camera will move]")
                cameraStartHandler?.dispose()
            }
        }
        
        func onCameraStopped(_ param: CameraActionEventParam) {
            if (param.by == .notUserAction) {
                    cameraStoppedHandler?.dispose()
            }
        }
        
        func getUserLocation() {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.distanceFilter = 20
            let coordinate = locationManager.location?.coordinate
            
            userLatitude = coordinate?.latitude ?? 37.402001
            userLongitude = coordinate?.longitude ?? 127.108678
            print("[Get: MyLocation] latitude = \(userLatitude), longitude = \(userLongitude)")
        }
        
        func containerDidResized(_ size: CGSize) {
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
           
            print("[Action: Resizing Container]")
            if first {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    /*  let cameraUpdate: CameraUpdate = CameraUpdate.make(target:
                     MapPoint(longitude: self.userLongitude, latitude: self.userLatitude), zoomLevel: 15, mapView: mapView!)*/
                    let cameraUpdate: CameraUpdate = CameraUpdate.make(target:
                                                                        MapPoint(longitude: 127.108678, latitude: 37.402001), zoomLevel: 15, mapView: mapView!)
                    mapView?.moveCamera(cameraUpdate)
                    print("[Get: Camera point] latitude = \(self.userLatitude), longitude = \(self.userLongitude)")
                }
                first = false
            }
        }
        
        // MARK: - Poi
        func createLabelLayer() {
            if let view = controller?.getView("mapview") as? KakaoMap{
                let manager = view.getLabelManager()
               
                let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 3000)
                manager.addLabelLayer(option: layerOption)
            }
        }
        
        // Poi 레벨별 표시 스타일 지정
        func createPoiStyle() {
            if let view = controller?.getView("mapview") as? KakaoMap {
                let manager = view.getLabelManager()
        
                let shopPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "markDefault")?.resized(withSize: CGSize(width: 45, height: 63)))
                let pickPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "markPressed")?.resized(withSize: CGSize(width: 60, height: 84)))
                let userLocationPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "myLocation")?.resized(withSize: CGSize(width: 150, height: 150)))
                
                let red = PoiTextLineStyle(textStyle: TextStyle(fontSize: 20, 
                                                                fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.red))
                let textStyle = PoiTextStyle(textLineStyles: [red])
                
                let shopPoiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
                    PerLevelPoiStyle(iconStyle: shopPoiIconStyle, textStyle: textStyle, level: 8),
                    PerLevelPoiStyle(iconStyle: shopPoiIconStyle, textStyle: textStyle, level: 18)
                ])
        
                let pickPoiStyle = PoiStyle(styleID: "pickPoiIconStyle", styles: [
                    PerLevelPoiStyle(iconStyle: pickPoiIconStyle, textStyle: textStyle, level: 8),
                    PerLevelPoiStyle(iconStyle: pickPoiIconStyle, textStyle: textStyle, level: 18)
                ])
                let userLocationPoiStyle = PoiStyle(styleID: "UserLocationStyle", styles: [
                    PerLevelPoiStyle(iconStyle: userLocationPoiIconStyle, level: 8),
                    PerLevelPoiStyle(iconStyle: userLocationPoiIconStyle, level: 18)
                ])
                manager.addPoiStyle(shopPoiStyle)
                manager.addPoiStyle(pickPoiStyle)
                manager.addPoiStyle(userLocationPoiStyle)
            }
        }
        
        // Poi 맵에 찍기
        // 매장위치 Poi
        func createPoisOnMap() {
            if let view = controller?.getView("mapview") as? KakaoMap {
                let manager = view.getLabelManager()
                let layer = manager.getLabelLayer(layerID: "PoiLayer")
                
                for markerData in markerTestDataManager.markerTestDatas {
                    let poiOption = PoiOptions(styleID: "PerLevelStyle")
                    poiOption.rank = 0
                    poiOption.transformType = .decal
                    
                    poiOption.addText(PoiText(text: markerData.name, styleIndex: 0))
                    poiOption.clickable = true
                    
                    let markerPoint = MapPoint(longitude: Double(markerData.longitude), latitude: markerData.latitude)
                    let marker = layer?.addPoi(option: poiOption, at: markerPoint)
                    marker?.userObject = markerData as AnyObject
                    let _ = marker?.addPoiTappedEventHandler(target: self, handler: KakaoMapCoordinator.poiDidTapped)
                    print("[Action: create Poi] markerData = \(markerData)")
                    marker?.show()
                }
            }
            createUserLocationPoi()
        }
        
        // 내위치 Poi
        func createUserLocationPoi() {
            if let view = controller?.getView("mapview") as? KakaoMap{
                let manager = view.getLabelManager()
                let layer = manager.getLabelLayer(layerID: "PoiLayer")
                let poiOption = PoiOptions(styleID: "UserLocationStyle")
                
                poiOption.rank = 0
                poiOption.transformType = .decal
                poiOption.clickable = true
                poiOption.addText(PoiText(text: "내위치", styleIndex: 1))
                let markerPoint = MapPoint(longitude: userLongitude, latitude: userLatitude)
                let marker = layer?.addPoi(option: poiOption, at: markerPoint)
                locationPoiID = marker?.itemID ?? ""
                print("[Action: Create PoiID \(locationPoiID)]")
                marker?.show()
            }
        }
        
        func newPositionUserPoi() {
            if let view = controller?.getView("mapview") as? KakaoMap{
                let manager = view.getLabelManager()
                let layer = manager.getLabelLayer(layerID: "PoiLayer")
                let marker = layer?.getPoi(poiID: locationPoiID)
                marker?.position = MapPoint(longitude: userLongitude, latitude: userLatitude)
            }
        }
        
        func poiDidTapped(_ param: PoiInteractionEventParam) {
            if let markerData = param.poiItem.userObject as? MarkerTestData {
                if let view = controller?.getView("mapview") as? KakaoMap{
                    let manager = view.getLabelManager()
                    let layer = manager.getLabelLayer(layerID: "PoiLayer")
                    
                    print("[Action: Tapped Poi] \npoi name : \(markerData.name)\npoi lo : \(markerData.longitude)\npoi la : \(markerData.latitude)")

                    if recentPoiId != param.poiItem.itemID {
                        moveCameraToFocus(MapPoint(longitude: Double(markerData.longitude), latitude: markerData.latitude))
                        isShowingSheet = true
                        
                        let tabMarker = layer?.getPoi(poiID: param.poiItem.itemID)
                        tabMarker?.changeStyle(styleID: "pickPoiIconStyle")
                        
                        if let recentMarkerId = recentPoiId {
                            let recentMarker = layer?.getPoi(poiID: recentMarkerId)
                            recentMarker?.changeStyle(styleID: "PerLevelStyle")
                        }
                        recentPoiId = param.poiItem.itemID
                    }
                }
               
            }
        }
        
        // MARK: - GPSButton
        func createSpriteGUI() {
            if let mapView = controller?.getView("mapview") as? KakaoMap {
                let guiManager = mapView.getGuiManager()
                let spriteGui = SpriteGui("Sprite")
                
                spriteGui.arrangement = .horizontal
                spriteGui.bgColor = UIColor.clear
                spriteGui.splitLineColor = UIColor.white
                
                spriteGui.origin = GuiAlignment(vAlign: .top, hAlign: .right)
                spriteGui.position = CGPoint(x: 50, y: 180)
                
                let gpsButton = GuiButton("GPS Button")
                gpsButton.image = UIImage(named: "location")?
                    .resized(withSize: CGSize(width: 100, height: 100))
                
                spriteGui.addChild(gpsButton)
                
                guiManager.spriteGuiLayer.addSpriteGui(spriteGui)
                spriteGui.delegate = self
                spriteGui.show()

            }
        }
        
        func guiDidTapped(_ gui: GuiBase, componentName: String) {
            NSLog("Gui: \(gui.name), Component: \(componentName) tapped")
            getUserLocation()
            moveCameraToFocus(MapPoint(longitude: userLongitude, latitude: userLatitude))
            newPositionUserPoi()
            gui.updateGui()
        }
        
        // 카메라 포커스
        func moveCameraToFocus(_ point: MapPoint){
            if let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let cameraUpdate: CameraUpdate = CameraUpdate
                        .make(target: MapPoint(from: point), zoomLevel: mapView.zoomLevel, mapView: mapView)
                    mapView.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(autoElevation: false, consecutive: false, durationInMillis: 50))
                    print("[Get: Camera point] latitude = \(self.userLatitude), longitude = \(self.userLongitude)")
                }
            }
        }
        
        func detailViewPoi(_ point: MapPoint) {
            print("[Action: Create detailViewPoi]")
            if let view = controller?.getView("mapview") as? KakaoMap{
                let manager = view.getLabelManager()
                let layer = manager.getLabelLayer(layerID: "PoiLayer")
                let poiOption = PoiOptions(styleID: "pickPoiIconStyle")
                poiOption.rank = 0
                let markerPoint = MapPoint(from: point)
                print("[Action: move to \(markerPoint)]")
                let marker = layer?.addPoi(option: poiOption, at: markerPoint)
                locationPoiID = marker?.itemID ?? ""
                print("[Action: Create PoiID \(locationPoiID)]")
                marker?.show()
                moveCameraToFocus(point)
            }
        }
    }
}

