//
//  EditPointViewController.swift
//  H-Nearer
//
//  Created by Mathis Chambon on 31/12/2021.
//

import UIKit
import CoreLocation

class EditPointViewController: UIViewController {

    var pointID: Int = 0
    
    @IBOutlet weak var titleLabel: UILabel!
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

        titleLabel.text = "Modifier le point \(Data.pointsArray[pointID].name)"
        nameField.text = "\(Data.pointsArray[pointID].name)"
        latitudeField.text = "\(Data.pointsArray[pointID].gpsPoint.coordinate.latitude)"
        longitudeField.text = "\(Data.pointsArray[pointID].gpsPoint.coordinate.longitude)"
        
        nameError.text = ""
        latitudeError.text = ""
        longitudeError.text = ""
        globalError.text = ""
    }

    @IBAction func onEditClick(_ sender: Any) {
        nameError.text = ""
        latitudeError.text = ""
        longitudeError.text = ""
        globalError.text = ""
        
        if nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || latitudeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || longitudeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            globalError.text = "Tout les champs doivent être remplis pour continuer !"

            return
        }

        if let latitude = Double(latitudeField.text!) {
            if !(-180...180 ~= latitude) {
                latitudeError.text = "La latitude entrée est invalide"
                return
            }
        } else {
            latitudeError.text = "La latitude entrée est invalide"
            return
        }

        if let longitude = Double(longitudeField.text!) {
            if !(-90...90 ~= longitude) {
                longitudeError.text = "La longitude entrée est invalide"
                return
            }
        } else {
            longitudeError.text = "La longitude entrée est invalide"
            return
        }
        
        Data.pointsArray[pointID] = Point(name: nameField.text!, gpsPoint: CLLocation(latitude: Double(latitudeField.text!) ?? 0.0, longitude: Double(longitudeField.text!) ?? 0.0))
        
        showAlert(title: "Done ! ✅", message: "Le point a bien été modifié ✏️", confirmationMessage: "Parfait !", handler: {(action) -> Void in
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
