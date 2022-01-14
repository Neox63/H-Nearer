//
//  PointArray.swift
//  H-Nearer
//
//  Created by Mathis Chambon on 28/12/2021.
//

import Foundation
import CoreLocation

struct Data {
    static var pointsArray: [Point] = [
        Point(name: "Hesias", gpsPoint: CLLocation(latitude: 45.76744672545919, longitude: 3.1326910419432266)),
        Point(name: "OpenStudio", gpsPoint: CLLocation(latitude: 45.779232887300985, longitude: 3.0818159977622277)),
        Point(name: "Rasso", gpsPoint: CLLocation(latitude: 45.76486026827541, longitude: 3.126662987870709)),
        Point(name: "Domicile", gpsPoint: CLLocation(latitude: 45.74316314052896, longitude: 3.2046783112520827)),
    ]
}
