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
                context.coordinator.controller?.startRendering()}}
        else {
            context.coordinator.controller?.stopRendering()
            context.coordinator.controller?.stopEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(userLatitude: $userLatitude, userLongitude: $userLongitude, isShowingSheet: $isShowingSheet)
    }

    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {

    }
    
    // MARK: - 맵
    class KakaoMapCoordinator: NSObject, MapControllerDelegate, GuiEventDelegate, KakaoMapEventDelegate {
        var controller: KMController?
        var first: Bool
        var markerTestDataManager = MarkerTestDataManager()
        var cameraStoppedHandler: DisposableEventHandler?
        var cameraStartHandler: DisposableEventHandler?
        private let locationManager = CLLocationManager()
        
        @Binding var userLatitude: Double
        @Binding var userLongitude: Double
        @Binding var isShowingSheet: Bool

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
                        .addCameraWillMovedEventHandler(target: self , handler: KakaoMapCoordinator.cameraWillMove)
                    cameraStoppedHandler = mapView
                        .addCameraStoppedEventHandler(target: self, handler: KakaoMapCoordinator.onCameraStopped)
                    getUserLocation()
                    createLabelLayer()
                    createPoiStyle()
                    createMarkersOnMap()
                    createSpriteGUI()
                    
                } else {
                    print("[Error: KakaoMap casting failure]")
                }
            }
        }
        
        func cameraWillMove(_ param: CameraActionEventParam) {
            if(param.by == .notUserAction) {
                print("[Action: Camera will move]")
                cameraStartHandler?.dispose()
            }
        }
        
        func onCameraStopped(_ param: CameraActionEventParam) {
            if(param.by == .notUserAction) {
                if let mapView = param.view as? KakaoMap {
                    cameraStoppedHandler?.dispose()
                }
            }
        }
        
        func getUserLocation(){
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            let coordinate = locationManager.location?.coordinate
            userLatitude = coordinate?.latitude ?? 37.402001
            userLongitude = coordinate?.longitude ?? 127.108678
            print("[Get: MyLocation] latitude = \(userLatitude), longitude = \(userLongitude)")
            moveCameraToFocus(MapPoint(longitude: userLongitude, latitude: userLatitude), zoomLevel: 15)
        }
        
        func containerDidResized(_ size: CGSize) {
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
            
            if first {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: 127.108678, latitude: 37.402001), zoomLevel: 15, mapView: mapView!)
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
                let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 1000)
                let _ = manager.addLabelLayer(option: layerOption)
            }
        }
        
        // Poi 레벨별 표시 스타일 지정
        func createPoiStyle() {
            if let view = controller?.getView("mapview") as? KakaoMap {
                let manager = view.getLabelManager()
                
                let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "marker"))
                let red = PoiTextLineStyle(textStyle: TextStyle(fontSize: 20, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.red))
                let blue = PoiTextLineStyle(textStyle: TextStyle(fontSize: 20, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.blue))
                let textStyle1 = PoiTextStyle(textLineStyles: [red, blue])
                
                let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
                    PerLevelPoiStyle(iconStyle: iconStyle1, textStyle: textStyle1, level: 8),
                    PerLevelPoiStyle(iconStyle: iconStyle1, textStyle: textStyle1, level: 18)
                ])
                manager.addPoiStyle(poiStyle)
            }
        }
        
        // Poi 맵에 찍기
        func createMarkersOnMap() {
            if let view = controller?.getView("mapview") as? KakaoMap{
                let manager = view.getLabelManager()
                let layer = manager.getLabelLayer(layerID: "PoiLayer")
                
                // 매장위치 Poi
                for markerData in markerTestDataManager.markerTestDatas {
                    let poiOption = PoiOptions(styleID: "PerLevelStyle")
                    poiOption.rank = 0
                    
                    poiOption.addText(PoiText(text: markerData.name, styleIndex: 0))
                    poiOption.clickable = true
                    
                    let markerPoint = MapPoint(longitude: Double(markerData.longitude), latitude: Double(markerData.latitude))
                    let marker = layer?.addPoi(option: poiOption, at: markerPoint)
                    marker?.userObject = markerData as AnyObject
                    let _ = marker?.addPoiTappedEventHandler(target: self , handler: KakaoMapCoordinator.poiDidTapped)
                    print("[Action: create Poi] markerData = \(markerData)")
                    marker?.show()
                }
                
                // 내위치 Poi
                let poiOption = PoiOptions(styleID: "PerLevelStyle")
                poiOption.rank = 0
                poiOption.clickable = true
                poiOption.addText(PoiText(text: "내위치", styleIndex: 1))
                let markerPoint = MapPoint(longitude: Double(userLongitude), latitude: Double(userLatitude))
                let marker = layer?.addPoi(option: poiOption, at: markerPoint)
                marker?.show()
            }
        }
        
        func poiDidTapped(_ param: PoiInteractionEventParam) {
            if let markerData = param.poiItem.userObject as? MarkerTestData {
                print("[Action: Tapped Poi] \npoi name : \(markerData.name)\npoi lo : \(markerData.longitude)\npoi la : \(markerData.latitude)")
                moveCameraToFocus(MapPoint(longitude: Double(markerData.longitude), latitude: Double(markerData.latitude)), zoomLevel: 17)
                isShowingSheet = true
            }
        }
        
        // MARK: - GPS
        func createSpriteGUI() {
            if let mapView = controller?.getView("mapview") as? KakaoMap {
                let guiManager = mapView.getGuiManager()
                let spriteGui = SpriteGui("testSprite")
                
                spriteGui.arrangement = .horizontal
                spriteGui.bgColor = UIColor.clear
                spriteGui.splitLineColor = UIColor.white
                
                spriteGui.origin = GuiAlignment(vAlign: .top, hAlign: .right)
                spriteGui.position = CGPoint(x: 20, y: 20)
                
                let button1 = GuiButton("button1")
                button1.image = UIImage(systemName: "paperplane.circle.fill")
                
                spriteGui.addChild(button1)
                
                let _ = guiManager.spriteGuiLayer.addSpriteGui(spriteGui)
                spriteGui.delegate = self
                spriteGui.show()
            }
        }
        
        func guiDidTapped(_ gui: GuiBase, componentName: String) {
            NSLog("Gui: \(gui.name), Component: \(componentName) tapped")
            
            // GuiButton을 포함하는 SpriteGui에서 특정 아이디의 GuiText Component를 가져옴
            let guitext = gui.getChild("text") as? GuiText
            getUserLocation()
            gui.updateGui()
        }
        
        // 카메라 포커스
        func moveCameraToFocus(_ point: MapPoint, zoomLevel: Int){
            if let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let cameraUpdate: CameraUpdate = CameraUpdate
                        .make(target: MapPoint(from: point), zoomLevel: zoomLevel, mapView: mapView)
                    //mapView?.moveCamera(cameraUpdate)
                    mapView.animateCamera(cameraUpdate : cameraUpdate, options: CameraAnimationOptions(autoElevation: false, consecutive: false, durationInMillis: 100))
                    
                    print("[Get: Camera point] latitude = \(self.userLatitude), longitude = \(self.userLongitude)")
                }
            }
        }
    }
}
