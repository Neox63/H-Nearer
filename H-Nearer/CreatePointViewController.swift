//
//  CreatePointViewController.swift
//  H-Nearer
//
//  Created by Mathis Chambon on 28/12/2021.
//

import UIKit
import CoreLocation

class CreatePointViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var latitudeError: UILabel!
    @IBOutlet weak var longitudeError: UILabel!
    @IBOutlet weak var globalError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        nameError.text = ""
        latitudeError.text = ""
        longitudeError.text = ""
        globalError.text = ""
    }
    
    @IBAction func onAutocompleteClick(_ sender: Any) {
        let locationManager: CLLocationManager? = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                latitudeField.text = "\(location.coordinate.latitude)"
                longitudeField.text = "\(location.coordinate.longitude)"
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    
    @IBAction func onAddPoint(_ sender: Any) {
        nameError.text = ""
        latitudeError.text = ""
        longitudeError.text = ""
        globalError.text = ""
        
        if nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || latitudeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || longitudeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            globalError.text = "Tout les champs doivent être remplis pour continuer !"

            return
        }
        
        for point in Data.pointsArray {
            if nameField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == point.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                nameError.text = "Un point existe déjà avec le nom \(point.name)"
                return
            }
        }

        if let latitude = Double(latitudeField.text!) {
            if !(-90...90 ~= latitude) {
                latitudeError.text = "La latitude entrée est invalide"
                return
            }
        } else {
            latitudeError.text = "La latitude entrée est invalide"
            return
        }

        if let longitude = Double(longitudeField.text!) {
            if !(-180...180 ~= longitude) {
                longitudeError.text = "La longitude entrée est invalide"
                return
            }
        } else {
            longitudeError.text = "La longitude entrée est invalide"
            return
        }
        
//       ---------------------------------
//       [ W I P ] - Persistance de donnée
//       ---------------------------------
        
//        -------------------------------------------------------------
//        Ajout de points via l'API avec une requête POST (Fonctionnel)
//        -------------------------------------------------------------
        
//        let group = DispatchGroup()
//        group.enter()
//        DispatchQueue.main.async {
//            Fetcher.createPoint(point: Point(name: self.nameField.text!, gpsPoint: CLLocation(latitude: Double(self.latitudeField.text!) ?? 0.0, longitude: Double(self.longitudeField.text!) ?? 0.0)), handler: {() -> Void in self.showAlert(title: "And... another one 😎", message: "Le point a bien été ajouté à la liste 📝", confirmationMessage: "Parfait !", handler: {(action) -> Void in
//                self.goToList()
//            })})
//        }
        
//        group.notify(queue: .main) {
//            self.showAlert(title: "And... another one 😎", message: "Le point a bien été ajouté à la liste 📝", confirmationMessage: "Parfait !", handler: {(action) -> Void in
//                self.goToList()
//            })
//        }
        
        Data.pointsArray.append(Point(name: nameField.text!, gpsPoint: CLLocation(latitude: Double(latitudeField.text!) ?? 0.0, longitude: Double(longitudeField.text!) ?? 0.0)))

        showAlert(title: "And... another one 😎", message: "Le point a bien été ajouté à la liste 📝", confirmationMessage: "Parfait !", handler: {(action) -> Void in
            self.goToList()
        })
        
        
    }
    
    func goToList() {
        performSegue(withIdentifier: "unwindToList", sender: self)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
