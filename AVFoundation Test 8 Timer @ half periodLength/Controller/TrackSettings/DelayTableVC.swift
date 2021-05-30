//
//  DelayTableVC.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 26.05.21.
//

import UIKit

protocol DelayTableVCDelegate {
    func changeDelayWetDryMix(toValue: Float)
    func changeDelayFeedback(toValue: Float)
    func changeDelayPreset(to: SyncDelay)
}

class DelayTableVC: UITableViewController {
    
    var delegate: DelayTableVCDelegate?

    
    @IBOutlet weak var delayWetDryMixSlider: UISlider!
    @IBOutlet weak var delayFeedBackSlider: UISlider!
    @IBOutlet weak var delayTimeLabel: UILabel!
    @IBOutlet weak var delayStepper: UIStepper!
    
    var delayWetDryMix: Float?
    var delayFeedback: Float?
    var delayPreset: SyncDelay?
    var delayTime: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Delay"
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let wetdrymix = delayWetDryMix {
            delayWetDryMixSlider.value = wetdrymix / K.Sequencer.delayScalingFactor
            print("DEL03 mix \(wetdrymix / K.Sequencer.delayScalingFactor)")
            
        }
        if let feedback = delayFeedback {
            delayFeedBackSlider.value = feedback
            print("DEL03 feedback \(feedback)")
            
        }
        if let delPreset = delayPreset {
            delayTimeLabel.text = delPreset.description
            print("DEL03 Preset  \(delPreset.description)")
            //delayStepper.value = Double(revType)
        }
        
        if let currentDelayPresetIndex = delayPreset?.rawValue {
            delayStepper.value = Double(currentDelayPresetIndex)
           // print(currentDelayPresetIndex)
        }
    }
}

//
// MARK:- Events
//
extension DelayTableVC {
    
    @IBAction func delayWetDryMixChanged(_ sender: UISlider) {
        print(#function)
        delegate?.changeDelayWetDryMix(toValue: sender.value * K.Sequencer.delayScalingFactor)
    }
    
    @IBAction func delayFeedbackChanged(_ sender: UISlider) {
        print(#function)
        delegate?.changeDelayFeedback(toValue: sender.value)
    }
    
    @IBAction func delayTimeChanged(_ sender: UIStepper) {
        print(#function)
        let newPresetIndex = Int(sender.value)
        if let newPreset = SyncDelay(rawValue: newPresetIndex) {
            delegate?.changeDelayPreset(to: newPreset)
            delayTimeLabel.text = newPreset.description
            //print("newPreset: \(newPreset)")
        }
    }
    
    
}
