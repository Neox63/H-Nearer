//
//  Fetcher.swift
//  H-Nearer
//
//  Created by Mathis Chambon on 13/01/2022.
//

import Foundation
import CoreLocation

//       ---------------------------------
//       [ W I P ] - Persistance de donnée
//       ---------------------------------
        
//        -----------------------------------------------
//        Utilitaire de fetching de data via requête HTTP
//        -----------------------------------------------

let BASE_URL = "https://h-nearer-api.herokuapp.com"

struct Fetcher {

    static func getPoints(completion: @escaping ([Point]) -> ()) {
        struct point: Decodable {
            let id: Int
            let name: String
            let latitude: String
            let longitude: String
        }
        
        guard let url = URL(string: "\(BASE_URL)/points") else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
               if let error = error {
                   print("Something went wrong : \(error)")
                   completion([])
                   return
               }

               guard let data = data else {
                   completion([])
                   return
               }

               do {
                   let points = try JSONDecoder().decode([point].self, from: data)
                   var pointsList: [Point] = []
                   for point in points {
                       let currentPoint = Point(name: point.name, gpsPoint: CLLocation(latitude: Double(point.latitude) ?? 0, longitude: Double(point.longitude) ?? 0))
                       pointsList.append(currentPoint)
                   }
                   completion(pointsList)
               } catch {
                   print(error)
               }
        }.resume()
    }
    
    static func createPoint(point: Point, handler: @escaping () -> Void = { }) {
        let parameters: [String: Any] = ["name": point.name, "latitude": point.gpsPoint.coordinate.latitude, "longitude": point.gpsPoint.coordinate.longitude]

        let url = URL(string: "\(BASE_URL)/points/create")!

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    return
                }
                print(json)
            } catch let error {
                print("catch : \(error.localizedDescription)")
            }
        })

        task.resume()
    }
}
