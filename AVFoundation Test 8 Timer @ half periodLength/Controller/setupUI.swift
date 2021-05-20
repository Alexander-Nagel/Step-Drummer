//
//  setupUI.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 18.05.21.
//

import Foundation
import UIKit
//
// MARK: - Setup UI
//
extension MainVC {
    func setupUI() {
        
        //
        // Init button/label arrays
        //
     
        
        track0Buttons = [button0_0, button0_1, button0_2, button0_3,
                         button0_4, button0_5, button0_6, button0_7,
                         button0_8, button0_9, button0_10, button0_11,
                         button0_12, button0_13, button0_14, button0_15]
        track1Buttons = [button1_0, button1_1, button1_2, button1_3,
                         button1_4, button1_5, button1_6, button1_7,
                         button1_8, button1_9, button1_10, button1_11,
                         button1_12, button1_13, button1_14, button1_15]
        track2Buttons = [button2_0, button2_1, button2_2, button2_3,
                         button2_4, button2_5, button2_6, button2_7,
                         button2_8, button2_9, button2_10, button2_11,
                         button2_12, button2_13, button2_14, button2_15]
        track3Buttons = [button3_0, button3_1, button3_2, button3_3,
                         button3_4, button3_5, button3_6, button3_7,
                         button3_8, button3_9, button3_10, button3_11,
                         button3_12, button3_13, button3_14, button3_15]
        trackButtonMatrix = [track0Buttons, track1Buttons, track2Buttons, track3Buttons]
        
        muteButtons = [mute0Button, mute1Button, mute2Button, mute3Button]
        trackSettingsButtons = [settingsButton0, settingsButton1, settingsButton2, settingsButton3 ]
        stepperButtons = [stepper0Button, stepper1Button, stepper2Button, stepper3Button]
        stepperViews = [stepper0View, stepper1View, stepper2View, stepper3View ]
        controlButtons = [playPauseButton, tapButton,/*  bpmLabel, bpmStepper, */ picker]
//        trackVolumeSliders = [volumeSlider0, volumeSlider1, volumeSlider2, volumeSlider3]
//        trackReverbSliders = [reverbSlider0, reverbSlider1, reverbSlider2, reverbSlider3]
//        trackDelaySliders = [delaySlider0, delaySlider1, delaySlider2, delaySlider3]
//        trackSliders = trackVolumeSliders + trackReverbSliders + trackDelaySliders
        
        //
        // MARK: - Track control description labels:
        //
        
      
//        trackCellsView.isHidden = true
//        trackControlsLabelsStackView.isHidden = true
        
        //
        // MARK: - Track controls:
        //
       
        // VOLUME sliders:
        //
        for (index, slider) in trackVolumeSliders.enumerated() {
            slider.tag = index
            slider.tintColor = K.Color.orange
        }
        
        // REVERB sliders:
        //
        for (index, slider) in trackReverbSliders.enumerated() {
            slider.tag = index
            slider.tintColor = K.Color.orange
            
        }
        
        // DELAY sliders:
        //
        for (index, slider) in trackDelaySliders.enumerated() {
            slider.tag = index
            slider.tintColor = K.Color.orange
        }

        
        // NUMBER OF CELLS Stepper:
        
//        for view in stepperViews {
//            view.backgroundColor = K.Color.muteButtonColor
//        }
//        for (index, stepper) in stepperButtons.enumerated() {
//            stepper.backgroundColor = K.Color.muteButtonColor
//
//            stepper.minimumValue = 1
//            stepper.maximumValue = 16
//            stepper.stepValue = 1
//            stepper.tag = index
//            stepper.value = Double(seq.tracks[index].numberOfCellsActive)
//        }
        
        // MUTE buttons:
        //
        for (index, button) in muteButtons.enumerated() {
            //print("Index: \(index)")
            button.backgroundColor = K.Color.muteButtonColor
            button.layer.borderColor = K.Color.muteButtonBorderColor.cgColor
            button.layer.borderWidth = 1.0
            button.tintColor = K.Color.white
            button.isHidden = false
            //            button.titleLabel?.text = "AA"
           // button.setTitleColor(K.Color.black, for: .normal)
            button.layer.cornerRadius = 15
            // button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.tag = index
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
        }
        // TRACK SETTINGS buttons:
        //
        for (index, button) in trackSettingsButtons.enumerated() {
            //print("Index: \(index)")
            button.backgroundColor = K.Color.muteButtonColor
            //button.layer.borderColor = K.Color.muteButtonBorderColor.cgColor
            button.layer.borderWidth = 1.0
            button.tintColor = K.Color.white
            button.isHidden = false
            //            button.titleLabel?.text = "AA"
           // button.setTitleColor(K.Color.black, for: .normal)
            button.layer.cornerRadius = 15
            // button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.tag = index
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
        }
        
        
        //
        // MARK: - Cells:
        //
        
        // Style & hide all step/"Cell" buttons:
        //
        let allButtons = track0Buttons + track1Buttons + track2Buttons + track3Buttons
        for (index, button) in allButtons.enumerated() {
            print("Index: \(index)")
            //button.backgroundColor = .none
            button.layer.borderColor = K.Color.blue_brighter.cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = false
            button.titleLabel?.text = ""
            button.layer.cornerRadius = 5
            button.tag = index
            //button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
            //button.addGestureRecognizer(leftSwipeButton)
            // button.addTarget(self, action: #selector(btnPressedAction), for: .allTouchEvents)
        }
        
        //
        // MARK: - Bottom control bar:
        //
        

        // SETTINGS button:
        //
//        settingsButton.backgroundColor = K.Color.orange
//        settingsButton.tintColor = K.Color.white
//        settingsButton.setTitleColor(K.Color.black, for: .normal)
//        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        settingsButton.layer.cornerRadius = 15
        
        // PART A/B/C/D segmented control:
        //
        partSegmentedControl.selectedSegmentTintColor = K.Color.controlButtonsSelectedColor
        partSegmentedControl.backgroundColor = K.Color.controlButtonsColor
        
        // SOFT MODE button:
        //
//        softModeButton.setTitleColor(.black, for: .normal)
        softModeButton.backgroundColor = K.Color.blue_brighter
        softModeButton.layer.cornerRadius = 0.125 * softModeButton.bounds.size.width
        softModeButton.tintColor = K.Color.white
        softModeButton.titleLabel?.textColor = K.Color.white

        
        // DELETE button:
        //
//        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.backgroundColor = K.Color.blue_brighter
        deleteButton.layer.cornerRadius = 0.125 * deleteButton.bounds.size.width
        deleteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deleteButton.tintColor = K.Color.white
        deleteButton.titleLabel?.textColor = K.Color.white

        
        // COPY button:
        //
//        copyButton.setTitleColor(.black, for: .normal)
        copyButton.backgroundColor = K.Color.blue_brighter
        copyButton.layer.cornerRadius = 0.125 * copyButton.bounds.size.width
        copyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        copyButton.tintColor = K.Color.white
        copyButton.titleLabel?.textColor = K.Color.white
        
        // CHAIN button:
        //
//        chainButton.setTitleColor(.black, for: .normal)
        chainButton.backgroundColor = K.Color.blue_brighter
        chainButton.layer.cornerRadius = 0.125 * tapButton.bounds.size.width
        chainButton.titleLabel?.adjustsFontSizeToFitWidth = true
        chainButton.tintColor = K.Color.white
        chainButton.titleLabel?.textColor = K.Color.white
        chainButton.setTitle(ChainModeNames.OFF.description, for: .normal)

//        let font = UIFont.systemFont(ofSize: 20)
//        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        let font = UIFont.systemFont(ofSize: 24)
        partSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)

//        bpmStepper.minimumValue = 30
//        bpmStepper.maximumValue = 300
//        bpmStepper.stepValue = 1
//        bpmStepper.value = seq.tempo!.bpm
//        bpmLabel.text = String(seq.tempo!.bpm)
//        bpmStepperView.backgroundColor = K.Color.controlButtonsColor
//        bpmStepper.isHidden = true
//        bpmStepperView.isHidden = true
        
        // TAP button:
        //
//        tapButton.setTitleColor(.black, for: .normal)
        tapButton.backgroundColor = K.Color.blue_brighter
        tapButton.layer.cornerRadius = 0.125 * tapButton.bounds.size.width
        tapButton.tintColor = K.Color.white
        tapButton.titleLabel?.textColor = K.Color.white
        
        // BPM picker:
        //
        
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(90, inComponent: 0, animated: true) // start at 120 bpm
        picker.selectRow(0, inComponent: 1, animated: true) // decimal point
        picker.selectRow(0, inComponent: 2, animated: true) // start at 0 as decimal
        picker.tintColor = .white
        picker.backgroundColor = K.Color.controlButtonsColor
        picker.layer.cornerRadius = 0.125 * picker.bounds.size.width
        
        // PLAY button:
        //
        playPauseButton.setTitleColor(.white, for: .normal)
        playPauseButton.backgroundColor = K.Color.blue_brighter
        playPauseButton.layer.cornerRadius = 0.125 * playPauseButton.bounds.size.width
        playPauseButton.tintColor = K.Color.white
        playPauseButton.titleLabel?.textColor = K.Color.white
    }
}
