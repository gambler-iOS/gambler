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
        userLocate.latitude = coordinate?.latitude ?? GeoPoint.defaultPoint.latitude
        userLocate.longitude = coordinate?.longitude ?? GeoPoint.defaultPoint.longitude
        print("[Get: MyLocation] latitude = \(userLocate.latitude), longitude = \(userLocate.longitude)")
    }
    
    func newPositionUserPoi() {
        if let mapView = controller?.getView("mapview") as? KakaoMap {
            let manager = mapView.getLabelManager()
            let layer = manager.getLabelLayer(layerID: "myLocationLayer")
            let marker = layer?.getPoi(poiID: locationPoiID)
            marker?.position =  MapPoint(longitude: userLocate.longitude, latitude: userLocate.latitude)
        }
    }
    
    func moveCameraToFocus(_ point: MapPoint) {
        if let mapView = controller?.getView("mapview") as? KakaoMap {
            DispatchQueue.main.async {
                let cameraUpdate: CameraUpdate = CameraUpdate
                    .make(target: MapPoint(from: point), zoomLevel: mapView.zoomLevel, mapView: mapView)
                mapView.animateCamera(cameraUpdate: cameraUpdate, 
                                      options: CameraAnimationOptions(autoElevation: false,
                                                                      consecutive: false, durationInMillis: 200))
            }
        }
    }
    
    func poiDidTapped(_ param: PoiInteractionEventParam) {
          if let markerData = param.poiItem.userObject as? Shop {
              if let view = controller?.getView("mapview") as? KakaoMap {
                  let manager = view.getLabelManager()
                  let layer = manager.getLabelLayer(layerID: "tappedPoiLayer")
                  let marker = layer?.getPoi(poiID: tapPoiId)
                
                  if recentPoiId != param.poiItem.itemID {
                      self.moveCameraToFocus(MapPoint(longitude: Double(markerData.location.longitude),
                                                      latitude: markerData.location.latitude))
                      if firstTap {
                          createTappedPoi(mapPoint: MapPoint(longitude: Double(markerData.location.longitude),
                                                             latitude: markerData.location.latitude))
                          firstTap = false
                      }
                      
                      let tabMarker = layer?.getPoi(poiID: param.poiItem.itemID)
                      marker?.position =  MapPoint(longitude: markerData.location.longitude, latitude: markerData.location.latitude)
                      
                      recentPoiId = param.poiItem.itemID
                      selectedShop = markerData
                      marker?.show()
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
   
   func createTappedPoi(mapPoint: MapPoint) {
          if let view = controller?.getView("mapview") as? KakaoMap {
              let manager = view.getLabelManager()
              let layer = manager.getLabelLayer(layerID: "tappedPoiLayer")
              let poiOption = PoiOptions(styleID: "pickPoiIconStyle")
              
              poiOption.rank = 0
              poiOption.transformType = .decal
              poiOption.clickable = true
              
              let markerPoint = mapPoint
              let marker = layer?.addPoi(option: poiOption, at: markerPoint)
              tapPoiId = marker?.itemID ?? ""
              print("[Action: Create PoiID \(locationPoiID)]")
              marker?.show()
          }
      }
    
    @MainActor
    func createPoisOnMap() {
        if let mapView = controller?.getView("mapview") as? KakaoMap {
            let manager = mapView.getLabelManager()
            let layer = manager.getLabelLayer(layerID: "PoiLayer")
            for markerData in mapViewModel.fetchNewShopList {
                let poiOption = PoiOptions(styleID: "shopPoiIconStyle")
                poiOption.rank = 0
                poiOption.transformType = .decal
                poiOption.clickable = true
                
                let markerPoint = MapPoint(longitude: Double(markerData.location.longitude),
                                           latitude: markerData.location.latitude)
                let marker = layer?.addPoi(option: poiOption, at: markerPoint)
                marker?.userObject = markerData as AnyObject
                _ = marker?.addPoiTappedEventHandler(target: self,
                                                         handler: KakaoMapView.KakaoMapCoordinator.poiDidTapped)
                marker?.show()
            }
        }
    }
    
    func createUserLocationPoi() {
        if let mapView = controller?.getView("mapview") as? KakaoMap {
            let manager = mapView.getLabelManager()
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
        if let mapView = controller?.getView("mapview") as? KakaoMap {
            let manager = mapView.getLabelManager()
            
            let shopPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "markDefault")?
                .resized(withSize: CGSize(width: 49, height: 69)))
            let pickPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "markPressed")?
                .resized(withSize: CGSize(width: 66, height: 92)))
            let userLocationPoiIconStyle = PoiIconStyle(symbol: UIImage(named: "myLocation")?
                .resized(withSize: CGSize(width: 160, height: 160)))
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
            spriteGui.position = CGPoint(x: getSafeAreaTop(),
                                         y: UIScreen.main.bounds.height + 50)
            
            let gpsButton = GuiButton("GPS Button")
            gpsButton.image = UIImage(named: "Location")?
                .resized(withSize: CGSize(width: 100, height: 100))
            
            spriteGui.addChild(gpsButton)
            guiManager.spriteGuiLayer.addSpriteGui(spriteGui)
            spriteGui.delegate = self
            spriteGui.show()
        }
    }
    
    func createLabelLayer() {
        if let mapView = controller?.getView("mapview") as? KakaoMap {
            let manager = mapView.getLabelManager()
            
            let markerLayerOption = LabelLayerOptions(layerID: "PoiLayer"
                                                      ,competitionType: .none,
                                                      competitionUnit: .symbolFirst,
                                                      orderType: .rank, zOrder: 5000)
            _ = manager.addLabelLayer(option: markerLayerOption)
            
            let tappedMarkerLayerOption = LabelLayerOptions(layerID: "tappedPoiLayer"
                                                            ,competitionType: .none,
                                                            competitionUnit: .symbolFirst,
                                                            orderType: .rank, zOrder: 6000)
            _ = manager.addLabelLayer(option: tappedMarkerLayerOption)
            
            let myLocationLayerOption =  LabelLayerOptions(layerID: "myLocationLayer"
                                                           ,competitionType: .none, 
                                                           competitionUnit: .symbolFirst,
                                                           orderType: .rank, zOrder: 7000)
            _ = manager.addLabelLayer(option: myLocationLayerOption)
            
           
        }
    }
}
