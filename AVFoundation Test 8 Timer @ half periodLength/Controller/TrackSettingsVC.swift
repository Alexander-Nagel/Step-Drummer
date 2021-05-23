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
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    @IBOutlet weak var selectedSoundLabel: UILabel!
    
    var fileNames = [String?]()
    var currentPlayer: Int?
    var selectedSound: String?
    var volume: Float?
    var delegate: TrackSettingsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = K.Color.blue

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        selectedSoundLabel.text = selectedSound ?? "-"
        if let vol = volume {
            volumeSlider.value = vol
        }

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
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        print(sender.value)
        (delegate as! MainVC).seq.volumes[currentPlayer!] = sender.value
        (delegate as! MainVC).seq.players[currentPlayer!].volume = sender.value
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = K.Color.blue
          //  headerView.backgroundView?.backgroundColor = K.Color.blue_brighter
            headerView.textLabel?.textColor = K.Color.white
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // cell.contentView.backgroundColor = K.Color.blue
        //cell.accessoryView?.backgroundColor = K.Color.blue

    }
    
}
