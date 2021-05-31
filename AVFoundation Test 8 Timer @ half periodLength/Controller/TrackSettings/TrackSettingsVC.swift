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

class TrackSettingsVC: UITableViewController {
    
    
    
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
    
    var delayWetDryMix: Float?
    var delayFeedback: Float?
    var delayPreset: SyncDelay?
    var delayTime: Double?

    var distortionWetDryMix: Float?
    var distortionPreGain: Float?
    var distortionPreset: AVAudioUnitDistortionPreset?
    
    var delegate: TrackSettingsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //    rtVC.popoverPresentationController?.passthroughViews = [self.view, (delegate as! MainVC).view]

            
            rtVC.delegate = self
            
            rtVC.reverbWetDryMix = self.reverbWetDryMix
            rtVC.reverbType = self.reverbType
            
            print("REV02 mix \(self.reverbWetDryMix)")
            print("REV02 type  \(self.reverbType)")
            
        }
        
        if segue.identifier == "goToDelayTableVC" {
            let dtVC = segue.destination as! DelayTableVC
            dtVC.popoverPresentationController?.delegate = self
        //    dtVC.popoverPresentationController?.passthroughViews = [self.view, (delegate as! MainVC).view]
            
            dtVC.delegate = self

            dtVC.delayWetDryMix = self.delayWetDryMix
            dtVC.delayFeedback = self.delayFeedback
            dtVC.delayTime = self.delayTime
            dtVC.delayPreset = self.delayPreset
        }
        
        if segue.identifier == "goToDistortionTableVC" {
            let ditVC = segue.destination as! DistortionTableVC
            ditVC.popoverPresentationController?.delegate = self
            //ditVC.popoverPresentationController?.passthroughViews = [self.view, (delegate as! MainVC).view]
            
            ditVC.delegate = self

            ditVC.distortionWetDryMix = self.distortionWetDryMix
            ditVC.distortionPreGain = self.distortionPreGain
            ditVC.distortionPreset = self.distortionPreset
        }
    }
}

//
// MARK:- Events
//
extension TrackSettingsVC {
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        print(sender.value)
        (delegate as! MainVC).seq.volumes[currentPlayer!] = sender.value
        (delegate as! MainVC).seq.players[currentPlayer!].volume = sender.value
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


//
// MARK:- Popover
//
extension TrackSettingsVC: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

//
// MARK:- SoundSelectionTableVCDelegate
//
extension TrackSettingsVC: SoundSelectionTableVCDelegate {
    
    func loadFile(name: String) {
        
        if let player = currentPlayer {
            delegate?.loadFile(name: name, toPlayer: player)
            (delegate as! MainVC).saveSnapShot(fileName: "default")
            selectedSoundLabel.text = name
        }
    }
}

//
// MARK:- Table View 
//
extension TrackSettingsVC {
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if let headerView = view as? UITableViewHeaderFooterView {
//            //     headerView.contentView.backgroundColor = K.Color.blue
//            //  headerView.backgroundView?.backgroundColor = K.Color.blue_brighter
//            //     headerView.textLabel?.textColor = K.Color.white
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // cell.contentView.backgroundColor = K.Color.blue
//        //cell.accessoryView?.backgroundColor = K.Color.blue
//        
//    }
//
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}

//
// MARK:- ReverbTableVC Delegate
//
extension TrackSettingsVC: ReverbTableVCDelegate {
    
    func changeWetDryMix(toValue value: Float) {
        print("Setting player \(currentPlayer!) to WetDryMix of \(value)")
        reverbWetDryMix = value
        (delegate as! MainVC).seq.reverbWetDryMixes[currentPlayer!] = value
        (delegate as! MainVC).seq.reverbs[currentPlayer!].wetDryMix = value
    }
    
    func changeReverbType(to value: Int) {
        print("Setting player \(currentPlayer!) reverb typ to \(value)")
        reverbType = value
        (delegate as! MainVC).seq.reverbTypes[currentPlayer!] = value
        
        guard let newPreset = AVAudioUnitReverbPreset(rawValue: value) else {
            fatalError("Error changing reverb preset!")
        }
        (delegate as! MainVC).seq.reverbs[currentPlayer!].loadFactoryPreset(newPreset)
    }
}

//
// MARK:- DelayTableVC Delegate
//
extension TrackSettingsVC: DelayTableVCDelegate {
    
    func changeDelayWetDryMix(toValue value: Float) {
        print(#function)
        print("Setting player \(currentPlayer!) to WetDryMix of \(value)")
        delayWetDryMix = value
        (delegate as! MainVC).seq.delayWetDryMixes[currentPlayer!] = value
        (delegate as! MainVC).seq.delays[currentPlayer!].wetDryMix = value
    }
    
    func changeDelayFeedback(toValue value: Float) {
        print(#function)
        print("Setting player \(currentPlayer!) to Feedback of \(value)")
        delayFeedback = value
        (delegate as! MainVC).seq.delayFeedbacks[currentPlayer!] = value
        (delegate as! MainVC).seq.delays[currentPlayer!].feedback = value
    }
    
    func changeDelayPreset(to newPreset: SyncDelay) {
        print(#function)
        print("Setting player \(currentPlayer!) delay type to \(newPreset)")
        delayPreset = newPreset
        
        if let barDuration = (delegate as! MainVC).seq.tempo?.fourBeatsInSeconds {
            let newTime = newPreset.factor * barDuration
            print("newTime: \(newTime)")
            (delegate as! MainVC).seq.delays[currentPlayer!].delayTime = newTime
            (delegate as! MainVC).seq.delayPresets[currentPlayer!] = newPreset
        }
    }
}

//
// MARK:- DistortionTableVC Delegate
//
extension TrackSettingsVC: DistortionTableVCDelegate {
    
    func changeDistortionWetDryMix(toValue value: Float) {
        print(#function)
        print("Setting player \(currentPlayer!) to WetDryMix of \(value)")
        distortionWetDryMix = value
        (delegate as! MainVC).seq.distortionWetDryMixes[currentPlayer!] = value
        (delegate as! MainVC).seq.distortions[currentPlayer!].wetDryMix = value
        
    }
    
    func changeDistortionPreGain(to value: Float) {
        print(#function)
        print("Setting player \(currentPlayer!) to PreGain of \(value)")
        distortionPreGain = value
        (delegate as! MainVC).seq.distortionPreGains[currentPlayer!] = value
        (delegate as! MainVC).seq.distortions[currentPlayer!].preGain = value
        
    }
    
    func changeDistortionPreset(to value: Int) {
       
        print("Setting player \(currentPlayer!) distortion preset to \(value)")
        guard let newPreset = AVAudioUnitDistortionPreset(rawValue: value) else {
            fatalError("Error changing distortion preset!")
        }
        
        distortionPreset = newPreset
       
        (delegate as! MainVC).seq.distortionPresets[currentPlayer!] = newPreset
        (delegate as! MainVC).seq.distortions[currentPlayer!].loadFactoryPreset(newPreset)

        let newWetDry = (delegate as! MainVC).seq.distortions[currentPlayer!].wetDryMix
        let newPreGain = (delegate as! MainVC).seq.distortions[currentPlayer!].preGain
        
        print("New wetDry: \(newWetDry), new preGain: \(newPreGain)")

        

    }
    
}
