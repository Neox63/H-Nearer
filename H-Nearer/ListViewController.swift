//
//  ListViewController.swift
//  H-Nearer
//
//  Created by Mathis Chambon on 28/12/2021.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var pointsArray: [Point] = []
    var itemToEditID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       ---------------------------------
//       [ W I P ] - Persistance de donnée
//       ---------------------------------
        
//        ---------------------------------------------------
//        Récupération des données depuis l'API (Fonctionnel)
//        ---------------------------------------------------
        
//        let group = DispatchGroup()
//        group.enter()
//        DispatchQueue.main.async {
//            Fetcher.getPoints() {
//                results in self.pointsArray = results
//                group.leave()
//            }
//        }
//
//        group.notify(queue: .main) {
//            self.table.reloadData()
//        }

        refreshPointList()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .systemIndigo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshPointList() {
        pointsArray = Data.pointsArray
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        refreshPointList()
        DispatchQueue.main.async { self.table.reloadData() }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.backgroundColor = indexPath.row == Data.selectedPointID ? .systemGreen : .systemIndigo
        cell.textLabel?.text = "\(indexPath.row == Data.selectedPointID ? "✅ " : "")\(pointsArray[indexPath.row].name) - \(String(format: "%.8f", pointsArray[indexPath.row].gpsPoint.coordinate.latitude)) / \(String(format: "%.8f", pointsArray[indexPath.row].gpsPoint.coordinate.longitude))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Data.selectedPointID = indexPath.row
        showAlert(title: "Yay", message: "Le point \(Data.pointsArray[indexPath.row].name) est désormais actif ✅", confirmationMessage: "C'est parti !")
        table.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async { self.table.reloadData() }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteButton = UIContextualAction(style: .destructive, title: "Supprimer") { (action, view, completion) in
            if Data.pointsArray.count == 1 {
                self.showAlert(title: "Le der' des der'", message: "Vous ne pouvez pas avoir une liste de point vide 😉", confirmationMessage: "Compris !")
                
                completion(true)
            } else if Data.selectedPointID == indexPath.row {
                self.showAlert(title: "Wait a min 🧐", message: "Vous essayez de supprimer un point actif, ce n'est vraiment pas une bonne idée 😅", confirmationMessage: "Compris !")
                
                completion(true)
            } else {
                Data.pointsArray.remove(at: indexPath.row)
                self.refreshPointList()
                self.table.deleteRows(at: [indexPath], with: .automatic)
                
                completion(true)
            }
        }
             
        let editButton = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.itemToEditID = indexPath.row
            self.performSegue(withIdentifier: "goToEdit", sender: self)
            
            completion(false)
        }
        
        deleteButton.backgroundColor = .red
        editButton.backgroundColor = .blue
         
        let config = UISwipeActionsConfiguration(actions: [deleteButton, editButton])
        config.performsFirstActionWithFullSwipe = false
         
        return config
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditPointViewController {
            destination.pointID = itemToEditID
        }
    }
}
