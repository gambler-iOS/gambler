//
//  MapTestData.swift
//  gambler
//
//  Created by daye on 1/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

class MarkerTestDataManager {
    var markerTestDatas: [MarkerTestData]
    
    init() {
        markerTestDatas = [
            MarkerTestData(name: "판교1", longitude: 127.1122214051127, latitude: 37.395815438352216),
            MarkerTestData(name: "판교2", longitude: 127.11297786474694, latitude: 37.39568857499883),
            MarkerTestData(name: "판교3", longitude: 127.11000802973668, latitude: 37.395889599947324)
        ]
    }
}
