//
//  DistortionTableVC.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 30.05.21.
//
protocol DistortionTableVCDelegate {
    func changeDistortionWetDryMix(toValue: Float)
    func changeDistortionPreGain(to: Float)
    func changeDistortionPreset(to: Int)
}

import UIKit
import AVFoundation

class DistortionTableVC: UITableViewController {

    var delegate: DistortionTableVCDelegate?

    //
    // MARK:- Outlets
    //
    @IBOutlet weak var distortionWetDryMixSlider: UISlider!
    @IBOutlet weak var distortionPreGainSlider: UISlider!
    @IBOutlet weak var distortionPresetLabel: UILabel!
    @IBOutlet weak var distortionPresetStepper: UIStepper!
    
    
    var distortionWetDryMix: Float?
    var distortionPreGain: Float?
    var distortionPreset: AVAudioUnitDistortionPreset?

    //
    // MARK:- Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Distortion"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let wetdrymix = distortionWetDryMix {
            distortionWetDryMixSlider.value = wetdrymix
            print("DIST03 mix \(wetdrymix)")

        }
        
        if let preamp = distortionPreGain {
            distortionPreGainSlider.value = preamp
            print("DIST03 preamp \(preamp)")
        }

        if let distPreset = distortionPreset {
            distortionPresetLabel.text = distPreset.description
                
            print("DIST03 preset \(distPreset.description)")
            
            let newStepperValue = distPreset.rawValue
            distortionPresetStepper.value = Double(newStepperValue)
        }
    }
}

//
// MARK:- Events
//
extension DistortionTableVC {
   
    @IBAction func distortionWetDryMixChanged(_ sender: UISlider) {
        delegate?.changeDistortionWetDryMix(toValue: sender.value)
        
    }
   
    @IBAction func distortionPreGainChanged(_ sender: UISlider) {
        print(#function)
        delegate?.changeDistortionPreGain(to: sender.value)
        
    }
    
    
    @IBAction func distortionPresetChanged(_ sender: UIStepper) {
        let newDistPreset = Int(sender.value)
        delegate?.changeDistortionPreset(to: newDistPreset)
        distortionPresetLabel.text = AVAudioUnitDistortionPreset(rawValue: newDistPreset)?.description
        print("Changing to dist preset  \(newDistPreset.description)")
        
        //
        // Update wetDryMix & PreGain Slider after switching of presets
        //
        let mainVC = ((delegate as! TrackSettingsVC).delegate as! MainVC) // ugly...
        let trackSettingsVC = (delegate as! TrackSettingsVC) // ugly...
        let currentplayer = trackSettingsVC.currentPlayer! // ugly...
        
        let newWetDry = mainVC.seq.distortions[currentplayer].wetDryMix
        let newPreGain = mainVC.seq.distortions[currentplayer].preGain
        
        print("New wetDry: \(newWetDry), new preGain: \(newPreGain)")
        
        distortionWetDryMixSlider.value = newWetDry
        distortionPreGainSlider.value = newPreGain
        
        
        
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
