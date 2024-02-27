//
//  KakaoMapView+Extension.swift
//  gambler
//
//  Created by daye on 2/28/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import KakaoMapsSDK
import CoreLocation

/// Feat
extension KakaoMapView.KakaoMapCoordinator {

    func getUserLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 20
        let coordinate = locationManager.location?.coordinate
        userLocate.latitude = coordinate?.latitude ?? 37.402001
        userLocate.longitude = coordinate?.longitude ?? 37.402001
        print("[Get: MyLocation] latitude = \(userLocate.latitude), longitude = \(userLocate.longitude)")
    }
    
    func newPositionUserPoi() {
        if let view = controller?.getView("mapview") as? KakaoMap {
            let manager = view.getLabelManager()
            let layer = manager.getLabelLayer(layerID: "myLocationLayer")
            let marker = layer?.getPoi(poiID: locationPoiID)
            marker?.position =  MapPoint(longitude: userLocate.longitude, latitude: userLocate.latitude)
        }
    }
    
    func moveCameraToFocus(_ point: MapPoint) {
        if let mapView: KakaoMap = controller?.getView("mapview") as? KakaoMap {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let cameraUpdate: CameraUpdate = CameraUpdate
                    .make(target: MapPoint(from: point), zoomLevel: mapView.zoomLevel, mapView: mapView)
                mapView.animateCamera(cameraUpdate: cameraUpdate, 
                                      options: CameraAnimationOptions(autoElevation: false,
                                                                      consecutive: false, durationInMillis: 50))
                print("[Get: Camera point] latitude = \(self.userLocate.latitude), longitude = \(self.userLocate.longitude)")
            }
        }
    }
    
    func poiDidTapped(_ param: PoiInteractionEventParam) {
        if let markerData = param.poiItem.userObject as? Shop {
            if let view = controller?.getView("mapview") as? KakaoMap {
                let manager = view.getLabelManager()
                let layer = manager.getLabelLayer(layerID: "PoiLayer")
                
                if recentPoiId != param.poiItem.itemID {
                    self.moveCameraToFocus(MapPoint(longitude: Double(markerData.location.longitude),
                                                    latitude: markerData.location.latitude))

                    let tabMarker = layer?.getPoi(poiID: param.poiItem.itemID)
                    tabMarker?.changeStyle(styleID: "pickPoiIconStyle")
                    
                    if let recentMarkerId = recentPoiId {
                        let recentMarker = layer?.getPoi(poiID: recentMarkerId)
                        recentMarker?.changeStyle(styleID: "shopPoiIconStyle")
                    }
                    recentPoiId = param.poiItem.itemID
                    selectedShop = markerData
                }
            }
        }
    }

    func guiDidTapped(_ gui: GuiBase, componentName: String) {
        print("Gui: \(gui.name), Component: \(componentName) tapped")
        getUserLocation()
        moveCameraToFocus(MapPoint(longitude: userLocate.longitude, latitude: userLocate.latitude))
        newPositionUserPoi()
        gui.updateGui()
    }
}

/// UI
extension KakaoMapView.KakaoMapCoordinator {
    
    func createPoisOnMap() {
        if let view = controller?.getView("mapview") as? KakaoMap {
            let manager = view.getLabelManager()
            let layer = manager.getLabelLayer(layerID: "PoiLayer")
            
            for markerData in Shop.dummyShopList {
                let poiOption = PoiOptions(styleID: "shopPoiIconStyle")
                poiOption.rank = 0
                poiOption.transformType = .decal
                poiOption.clickable = true
                
                let markerPoint = MapPoint(longitude: Double(markerData.location.longitude),
                                           latitude: markerData.location.latitude)
                let marker = layer?.addPoi(option: poiOption, at: markerPoint)
                marker?.userObject = markerData as AnyObject
                marker?.addPoiTappedEventHandler(target: self, handler: KakaoMapView.KakaoMapCoordinator.poiDidTapped)
                print("[Action: create Poi] markerData = \(markerData)")
                marker?.show()
            }
        }
    }
    
    func createUserLocationPoi() {
        if let view = controller?.getView("mapview") as? KakaoMap {
            let manager = view.getLabelManager()
            let layer = manager.getLabelLayer(layerID: "myLocationLayer")
            let poiOption = PoiOptions(styleID: "UserLocationStyle")
            
            poiOption.rank = 0
            poiOption.transformType = .decal
            poiOption.clickable = true
            
            let markerPoint = MapPoint(longitude: userLocate.longitude, latitude: userLocate.latitude)
            let marker = layer?.addPoi(option: poiOption, at: markerPoint)
            locationPoiID = marker?.itemID ?? ""
            print("[Action: Create PoiID \(locationPoiID)]")
            marker?.show()
        }
    }
   
    func createPoiStyle() {
        if let view = controller?.getView("mapview") as? KakaoMap {
            let manager = view.getLabelManager()
            
            let shopPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "markDefault")?
                .resized(withSize: CGSize(width: 45, height: 63)))
            let pickPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "markPressed")?
                .resized(withSize: CGSize(width: 60, height: 84)))
            let userLocationPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "myLocation")?
                .resized(withSize: CGSize(width: 150, height: 150)))
            let shopPoiStyle = PoiStyle(styleID: "shopPoiIconStyle", styles: [
                PerLevelPoiStyle(iconStyle: shopPoiIconStyle, level: 1)
            ])
            let pickPoiStyle = PoiStyle(styleID: "pickPoiIconStyle", styles: [
                PerLevelPoiStyle(iconStyle: pickPoiIconStyle, level: 1)
            ])
            let userLocationPoiStyle = PoiStyle(styleID: "UserLocationStyle", styles: [
                PerLevelPoiStyle(iconStyle: userLocationPoiIconStyle, level: 1)
            ])
            manager.addPoiStyle(shopPoiStyle)
            manager.addPoiStyle(pickPoiStyle)
            manager.addPoiStyle(userLocationPoiStyle)
        }
    }
    
    func createSpriteGUI() {
        if let mapView = controller?.getView("mapview") as? KakaoMap {
            let guiManager = mapView.getGuiManager()
            let spriteGui = SpriteGui("Sprite")
            
            spriteGui.arrangement = .horizontal
            spriteGui.bgColor = UIColor.clear
            spriteGui.splitLineColor = UIColor.white
            
            spriteGui.origin = GuiAlignment(vAlign: .top, hAlign: .right)
            spriteGui.position = CGPoint(x: getSafeAreaTop(), y: mapView.viewRect.height + mapView.viewRect.height/6)
            
            let gpsButton = GuiButton("GPS Button")
            gpsButton.image = UIImage(named: "location")?
                .resized(withSize: CGSize(width: 100, height: 100))
            
            spriteGui.addChild(gpsButton)
            
            guiManager.spriteGuiLayer.addSpriteGui(spriteGui)
            spriteGui.delegate = self
            spriteGui.show()
        }
    }
    
    func createLabelLayer() {
        if let view = controller?.getView("mapview") as? KakaoMap {
            let manager = view.getLabelManager()
            
            let markerLayerOption = LabelLayerOptions(layerID: "PoiLayer"
                                                      ,competitionType: .none,
                                                      competitionUnit: .symbolFirst,
                                                      orderType: .rank, zOrder: 5000)
            manager.addLabelLayer(option: markerLayerOption)
            let myLocationLayerOption =  LabelLayerOptions(layerID: "myLocationLayer"
                                                           ,competitionType: .none, 
                                                           competitionUnit: .symbolFirst,
                                                           orderType: .rank, zOrder: 6000)
            manager.addLabelLayer(option: myLocationLayerOption)
        }
    }
}
