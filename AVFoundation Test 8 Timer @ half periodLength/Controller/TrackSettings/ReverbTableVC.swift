//
//  ReverbTableVC.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 26.05.21.
//

import UIKit
import AVFoundation

protocol ReverbTableVCDelegate {
    func changeWetDryMix(toValue: Float)
    func changeReverbType(to: Int)
}

class ReverbTableVC: UITableViewController {

    var delegate: ReverbTableVCDelegate?
    var reverbWetDryMix: Float?
    var reverbType: Int?
    
    //
    // MARK:- Outlets
    //
    @IBOutlet weak var wetDryMixSlider: UISlider!
    @IBOutlet weak var reverbTypeLabel: UILabel!
    @IBOutlet weak var reverbTypeStepper: UIStepper!
    
    
    //
    // MARK:- Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Reverb"
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let wetdrymix = reverbWetDryMix {
            wetDryMixSlider.value = wetdrymix / K.Sequencer.reverbScalingFactor
            print("REV03 mix \(wetdrymix / K.Sequencer.reverbScalingFactor)")

        }
        if let revType = reverbType {
            if let revString = AVAudioUnitReverbPreset(rawValue: revType)?.string {
                reverbTypeLabel.text = revString
                print("REV03 type  \(revString)")
            }
            reverbTypeStepper.value = Double(revType)
        }
    }
}

//
// MARK:- Events
//
extension ReverbTableVC {
   
    @IBAction func wetDryMixChanged(_ sender: UISlider) {
        delegate?.changeWetDryMix(toValue: sender.value * K.Sequencer.reverbScalingFactor)
        
    }
    
    @IBAction func changeReverbType(_ sender: UIStepper) {
        let newReverbType = Int(sender.value)
        delegate?.changeReverbType(to: newReverbType)
        if let revString = AVAudioUnitReverbPreset(rawValue: newReverbType)?.string {
            reverbTypeLabel.text = revString
            print("Changing to rev type  \(revString)")
            
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
