//
//  TrackSettingsVC.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 20.05.21.
//

import UIKit
import AVFoundation

protocol TrackSettingsVCDelegate {
    func loadFile(name: String, toPlayer: Int)
}

class TrackSettingsVC: UITableViewController, UIPopoverPresentationControllerDelegate, SoundSelectionTableVCDelegate, ReverbTableVCDelegate {
   
    
    
    
    func loadFile(name: String) {
        
        if let player = currentPlayer {
            delegate?.loadFile(name: name, toPlayer: player)
            (delegate as! MainVC).saveSnapShot(fileName: "default")
            selectedSoundLabel.text = name
        }
    }
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    @IBOutlet weak var selectedSoundLabel: UILabel!
    
    @IBOutlet weak var reverbEditLabel: UILabel!
    
    @IBOutlet weak var delayEditLabel: UILabel!
    
    var fileNames = [String?]()
    var currentPlayer: Int?
    var selectedSound: String?
    var volume: Float?
    var reverbWetDryMix: Float?
    var reverbPreset: AVAudioUnitReverbPreset?
    var reverbType: Int?
    var delegate: TrackSettingsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = K.Color.blue

        
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
        
        if segue.identifier == "goToReverbTableVC" {
            let rtVC = segue.destination as! ReverbTableVC
            rtVC.popoverPresentationController?.delegate = self
            
            rtVC.delegate = self
            rtVC.reverbWetDryMix = self.reverbWetDryMix
            rtVC.reverbType = self.reverbType
            print("REV02 mix \(self.reverbWetDryMix)")
            print("REV02 type  \(self.reverbType)")

        }
        
//        if segue.identifier == "goToDelayTableVC" {
//            let dtVC = segue.destination as! DelayTableVC
//            dtVC.popoverPresentationController?.delegate = self
//        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        print(sender.value)
        (delegate as! MainVC).seq.volumes[currentPlayer!] = sender.value
        (delegate as! MainVC).seq.players[currentPlayer!].volume = sender.value
    }
    
    func changeDryWet(toValue value: Float) {
        print("Setting player \(currentPlayer!) to WetDryMix of \(value)")
        (delegate as! MainVC).seq.wetDryMixesReverb[currentPlayer!] = value
        (delegate as! MainVC).seq.reverbs[currentPlayer!].wetDryMix = value
    }
    func changeReverbType(to value: Int) {
        print("Setting player \(currentPlayer!) reverb typ to \(value)")
        (delegate as! MainVC).seq.reverbTypes[currentPlayer!] = value
        
        guard let newPreset = AVAudioUnitReverbPreset(rawValue: value) else {
            fatalError("Error changing reverb preset!")
        }
        (delegate as! MainVC).seq.reverbs[currentPlayer!].loadFactoryPreset(newPreset)
    }
}

//
// MARK:- Table View 
//
extension TrackSettingsVC {
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
       //     headerView.contentView.backgroundColor = K.Color.blue
          //  headerView.backgroundView?.backgroundColor = K.Color.blue_brighter
       //     headerView.textLabel?.textColor = K.Color.white
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // cell.contentView.backgroundColor = K.Color.blue
        //cell.accessoryView?.backgroundColor = K.Color.blue

    }
    
}
