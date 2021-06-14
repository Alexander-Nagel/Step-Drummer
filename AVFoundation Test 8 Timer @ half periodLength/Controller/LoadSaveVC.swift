//
//  LoadSaveVC.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 31.05.21.
//

protocol LoadSaveVCDelegate {
    func loadSnapshot(_ name: String)
    func saveSnapshot(name: String, partThatHasChanged: Int?, patternThatHasChanged: Int?)
    func deleteSnapshot(_ name: String)
    func updateUI()
}

import UIKit
import RealmSwift

class LoadSaveVC: UIViewController {
    
    let realm = try! Realm()
    var delegate: LoadSaveVCDelegate?
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
        
        fetchSnapshots()

        render()
        
//        guard let snapShot = realm.objects(SnapShot.self).first else {return}
//        print(snapShot.name)
//        print(snapShot.soundsArray)
        

       
    }
    
    func render() {
        
        let snaps = realm.objects(Snapshot.self)
        for shot in snaps {
            let name = shot.name
            
            print(name)
//            let label = UILabel(frame: view.bounds)
//            label.text = name
//            //label.textAlignment = .center
//            label.numberOfLines = 0
//            view.addSubview(label)
//            label.font = UIFont(name: "Helvetica", size: 42)
        }
    }
    
    

    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print(#function)
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
    
}

//
// MARK:- TableView Data Source
//
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

//
// MARK:- TableView Delegate
//
extension LoadSaveVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let results = snapshots?[indexPath.row] else { return }
        selectedSnapshotName = results.name
    }
}

//
//MARK: - Realm CRUD Actions
//
extension LoadSaveVC {
     
    //
    // MARK:- CREATE NEW
    //
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
    var textField = UITextField()
        
        // Create Alert, fetch snapshot name & create new Realm object
        //
        let alert = UIAlertController(title: "Save snapshot of current state", message: "Saves all patterns, all parts, track settings (selected sounds, volume, reverb, delay, distortion)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // Create new Realm object
            //
            self.delegate?.saveSnapshot(name: textField.text!, partThatHasChanged: nil, patternThatHasChanged: nil)
            self.tableView.reloadData()
            
//            let newSnapShot = Snapshot()
//            newSnapShot.name = textField.text!
//            self.saveSnapshot(snapshot: newSnapShot)
        }
        alert.addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Please Enter Snapshot Name"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //
    // MARK:- READ ALL
    //
    func fetchSnapshots() {
        
        snapshots = realm.objects(Snapshot.self)
        tableView.reloadData()
    }
    
    //
    // MARK:- READ SELECTED
    //
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        
        guard let name = selectedSnapshotName else { return }
        print("Loading \(name)")
        delegate?.loadSnapshot(name)
        delegate?.updateUI()
        dismiss(animated: true, completion: nil)
    }
    
    //
    // MARK:- UPDATE
    //
    func update() {
        
    }
    
    //
    // MARK:- DELETE
    //
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        guard let toBeDeleted = selectedSnapshotName else {
            showAlert(alertText: "No file selected!", alertMessage: "Select A file before pressing the Delete button!")
            return
        }
        
        if let snapshot = realm.objects(Snapshot.self).filter(NSPredicate(format: "name = %@", toBeDeleted)).first   {
            
//            try! realm.write{
//                realm.delete(snapshot)
//            }
//            print(realm.objects(Snapshot.self).first)
            
            delegate?.deleteSnapshot(toBeDeleted)
            
        } else {
            print("Snapshot not found!")
        }
        tableView.reloadData()
    }
    
}
