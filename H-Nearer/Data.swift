//
//  Data.swift
//  H-Nearer
//
//  Created by Mathis Chambon on 07/12/2021.
//

import Foundation
import CoreLocation

struct Data {
    static var pointsArray: [Point] = [
        Point(name: "Hesias", gpsPoint: CLLocation(latitude: 45.76744672545919, longitude: 3.1326910419432266)),
        Point(name: "Open Studio", gpsPoint: CLLocation(latitude: 45.779232887300985, longitude: 3.0818159977622277)),
        Point(name: "Place de Jaude", gpsPoint: CLLocation(latitude: 45.77652606451942, longitude: 3.082196395395022)),
        Point(name: "Apple Park", gpsPoint: CLLocation(latitude: 37.33469212005886, longitude: -122.00892874909117)),
        Point(name: "Puy de Dôme", gpsPoint: CLLocation(latitude: 45.77249106387585, longitude: 2.9648423447831185)),
    ]
    
    static var selectedPointID: Int = 0
}
