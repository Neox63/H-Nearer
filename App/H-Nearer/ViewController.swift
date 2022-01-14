//
//  ViewController.swift
//  H-Nearer
//
//  Created by Mathis Chambon on 06/12/2021.
//

import UIKit
import CoreLocation
import AudioToolbox
import QuartzCore

class ViewController: UIViewController, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager? = CLLocationManager()
    
    private var distance: Double = 0
    private var currentDistanceSlice: String = ""
    
    private var isNearingActivated: Bool = false
    private var isSoundActivated: Bool = true

    @IBOutlet weak var nearingButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var nearestPoint: UILabel!
    @IBOutlet weak var currentPos: UILabel!
    @IBOutlet weak var soundToggle: UISwitch!
    @IBOutlet weak var soundLabel: UILabel!
    
    private var currentDistance: Double = 0.0
    
    var pointsArray: [Point] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshPointList()
        
        currentPos.text = ""
        nearestPoint.text = ""
        nearingButton.setTitle("Activer le nearing 🚀", for: .normal)
        nearingButton.layer.backgroundColor = .init(red: 0, green: 128, blue: 0, alpha: 1)
        nearingButton.layer.cornerRadius = 180
        nearingButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        nearingButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        nearingButton.layer.shadowOpacity = 1.0
        nearingButton.layer.shadowRadius = 0.0
    }
    
    @IBAction func onSoundToggle(_ sender: Any) {
        isSoundActivated = soundToggle.isOn
        soundLabel.text = soundToggle.isOn ? "Sound On 🔊" : "Sound Off 🔇"
    }
    
    @IBAction func onNearingButtonClick(_ sender: Any) {
        isNearingActivated = !isNearingActivated;
        nearingButton.debounce(delay: 1.5)
        
        if isNearingActivated {
            activateNearing()
        } else {
            desactivateNearing()
        }
    }
    
    func refreshPointList() {
        pointsArray = Data.pointsArray
    }
    
    func activateNearing() {
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        nearingButton.setTitle("Désactiver le nearing", for: .normal)
        nearingButton.layer.backgroundColor = .init(red: 128, green: 0, blue: 0, alpha: 1)
        listButton.isEnabled = false
    }
    
    func desactivateNearing() {
        locationManager?.stopUpdatingLocation()
        currentPos.text = ""
        nearestPoint.text = ""
        distance = 0
        currentDistanceSlice = ""
        self.view.backgroundColor = .systemIndigo
        nearingButton.setTitle("Activer le nearing 🚀", for: .normal)
        nearingButton.layer.backgroundColor = .init(red: 0, green: 128, blue: 0, alpha: 1)
        listButton.isEnabled = true
        self.view.layer.removeAllAnimations()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            refreshPointList()
            let oldCurrentDistanceSlice: String = currentDistanceSlice
            distance = location.distance(from: pointsArray[Data.selectedPointID].gpsPoint)
            
            if distance <= 1 {
                isNearingActivated = false
                desactivateNearing()
                showAlert(title: "Bien joué ! 😄", message: "Vous êtes arrivé au point '\(pointsArray[Data.selectedPointID].name)'", confirmationMessage: "Super !")
            }
            
            switch distance {
                case _ where distance >= 1000:
                    currentDistanceSlice = ">1000"

                case _ where distance <= 500 && distance >= 251:
                    currentDistanceSlice = ">500"
                
                case _ where distance <= 250:
                    currentDistanceSlice = "<250"

                default:
                    return
            }
                            
            if !(oldCurrentDistanceSlice == currentDistanceSlice) {
                self.flashBackground()
            }
            
            currentPos.text = "📍 \(String(format: "%.8f", location.coordinate.latitude)) / \(String(format: "%.8f", location.coordinate.longitude))"
            nearestPoint.text = "\(pointsArray[Data.selectedPointID].name)" + (distance <= 1 ? " est juste ici !" : " est à " + (distance.rounded() > 1000 ? "\(distance.rounded() / 1000) km" : "\(distance.rounded())m"))
        }
    }
    
    func flashBackground() {
        var firstColor: UIColor
        var secondColor: UIColor
        var delay: TimeInterval
        
        switch distance {
            case _ where distance >= 1000:
                firstColor = .white
                secondColor = .green
                delay = 1

            case _ where distance <= 500 && distance >= 251:
                firstColor = .green
                secondColor = .orange
                delay = 0.75

            case _ where distance <= 250:
                firstColor = .orange
                secondColor = .red
                delay = 0.5

            default:
                return
        }
        
        UIView.animate(withDuration: 0, delay: delay, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.view.backgroundColor = firstColor
            
            if self.soundToggle.isOn {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                AudioServicesPlaySystemSound(1209)
            }
            
        }, completion: { finished in
            UIView.animate(withDuration: 0, delay: delay, options: [.allowUserInteraction, .curveEaseOut], animations: {
                self.view.backgroundColor = secondColor
                
                if self.soundToggle.isOn {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    AudioServicesPlaySystemSound(1209)
                }
                
            }, completion: { finished in
                if self.isNearingActivated {
                    Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.flashBackgroundAgain), userInfo: nil, repeats: false)
                } else {
                    self.view.backgroundColor = .systemIndigo
                }
            })
        })
    }

    @objc func flashBackgroundAgain() {
        flashBackground()
    }
}

public extension UIViewController {
    func showAlert(title: String, message: String, confirmationMessage: String, handler: @escaping (_ some: UIAlertAction) -> Void = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: confirmationMessage, style: .default, handler: handler)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

public extension UIControl {
    @objc static var debounceDelay: Double = 2
    @objc func debounce(delay: Double = UIControl.debounceDelay, siblings: [UIControl] = []) {
        let buttons = [self] + siblings
        buttons.forEach { $0.isEnabled = false }
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            buttons.forEach { $0.isEnabled = true }
        }
     }
}
