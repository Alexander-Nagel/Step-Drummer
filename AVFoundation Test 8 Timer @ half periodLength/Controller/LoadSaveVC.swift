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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        title = "Load / Save"
        
        // Disables dismissing by swiping down:
        //
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {}
        
        guard let snapShot = realm.objects(SnapShot.self).first else {return}
        print(snapShot.name)
        print(snapShot.soundsArray)
        
        
       
    }

    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print(#function)
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension LoadSaveVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "snapshotCell", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
}
