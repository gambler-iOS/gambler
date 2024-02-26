//
//  CalculateDistance.swift
//  gambler
//
//  Created by daye on 2/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import CoreLocation

struct Location {
    var latitude: Double
    var longitude: Double
}

func calculateDistanceBetweenPoints(point1: Location, point2: Location) -> CLLocationDistance {
    let location1 = CLLocation(latitude: point1.latitude, longitude: point1.longitude)
    let location2 = CLLocation(latitude: point2.latitude, longitude: point2.longitude)
    
    return location1.distance(from: location2)/1000
}
