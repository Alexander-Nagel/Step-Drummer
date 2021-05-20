//
//  TrackSettingsVC.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 20.05.21.
//

import UIKit

protocol TrackSettingsVCDelegate {
    func loadFile(name: String, toPlayer: Int)
}

class TrackSettingsVC: UITableViewController, UIPopoverPresentationControllerDelegate, SoundSelectionTableVCDelegate {
    
    func loadFile(name: String) {
        
        if let player = currentPlayer {
            delegate?.loadFile(name: name, toPlayer: player)
            selectedSoundLabel.text = name
        }
    }
    
    @IBOutlet weak var selectedSoundLabel: UILabel!
    
    var fileNames = [String?]()
    var selectedSound: String?
    var currentPlayer: Int?
    var delegate: TrackSettingsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
            selectedSoundLabel.text = selectedSound ?? "-"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

      
        if segue.identifier == "goToSoundSelectionVC" {
            let ssVC = segue.destination as! SoundSelectionTableVC
            ssVC.popoverPresentationController?.delegate = self

            ssVC.fileNames = fileNames
            ssVC.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
