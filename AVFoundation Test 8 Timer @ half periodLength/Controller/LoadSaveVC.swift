//
//  LoadSaveVC.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 31.05.21.
//

import UIKit
import RealmSwift

class LoadSaveVC: UIViewController {
    
    let realm = try! Realm()
    
    var snapshots: Results<Snapshot>?
    var selectedSnapshotName: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        //        title = "Load / Save"
        
        // Disables dismissing by swiping down:
        //
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {}
        
        loadSnapshots()

//        guard let snapShot = realm.objects(SnapShot.self).first else {return}
//        print(snapShot.name)
//        print(snapShot.soundsArray)
        

       
    }
    
    func loadSnapshots() {
        
        snapshots = realm.objects(Snapshot.self)
        tableView.reloadData()
    }

    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print(#function)
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print (indexPath.row)
        print(snapshots?[0].name)
        print(snapshots?[1].name)
        guard let results = snapshots?[indexPath.row] else { return }
        
        selectedSnapshotName = results.name
    }
    
}

extension LoadSaveVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapshots?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "snapshotCell", for: indexPath)
        
        if let snapshot = snapshots?[indexPath.row] {
            
            cell.textLabel?.text = snapshot.name
        }
//        cell.textLabel?.text = "test"
        return cell
    }
}

extension LoadSaveVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
    
}

extension LoadSaveVC {
    //
    //MARK: - Add New Snapshots
    //
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Save Snapshot Of Current State", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            //let newCategory = Category(context: self.context)
            let newSnapShot = Snapshot()
            
            newSnapShot.name = textField.text!
            //newSnapShot.soundsArray = TODO!!!!
        
            self.saveSnapshot(snapshot: newSnapShot)
        }
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancelAction)
        
        alert.addTextField { (field) in
            textField = field  
            field.placeholder = "Please Enter Snapshot Name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        
        guard let name = selectedSnapshotName else { return }
        print("Loading \(name)")
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        
    }
}

//
//MARK: - Data Manipulation Methods - save, load
//
extension LoadSaveVC {
    
    func saveSnapshot(snapshot: Snapshot) {
        do {
            
            try realm.write {
                realm.add(snapshot)
            }
        } catch {
            print("Error saving snapshot \(error)")
        }
        
        tableView.reloadData()
        
    }
}
