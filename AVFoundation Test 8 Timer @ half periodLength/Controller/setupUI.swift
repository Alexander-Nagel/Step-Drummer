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
        
        // create buttons programmatically in existing stack view "track4StackView"
        // from https://stackoverflow.com/a/58163607:
        
        func createButton() -> UIButton {
            let button = UIButton()
            //button.setTitle("btn 1", for: .normal)
            //button.backgroundColor = UIColor.red
            //button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderColor = K.Color.blue_brighter.cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = false
            button.titleLabel?.text = ""
            button.layer.cornerRadius = 5
            // button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            //button.tag = index
            return button
        }
        
        func createStackView() -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            return stackView
        }
        
       // let childStackView = UIStackView()
        //childStackView.axis = .horizontal
       //        childStackView.spacing = 0.0
       //        childStackView.alignment = .fill
       //        childStackView.distribution = .fillEqually
       //        childStackView.contentMode = .scaleToFill
       //        childStackView.autoresizesSubviews = true
       //        childStackView.backgroundColor = .yellow
        
        let numberOfBeats = 4
        let numberOfSubdivisions = 3
        
        for j in 0..<numberOfBeats{
            let stackView = createStackView()
            for i in 0..<numberOfSubdivisions {
                stackView.addArrangedSubview(createButton())
            }
            stackView.distribution = .fillEqually
            XXX.addArrangedSubview(stackView)
        }
       // XXX.addArrangedSubview(childStackView)
        XXX.distribution = .fillEqually
        XXX.alignment = .fill
        XXX.spacing = 12

//        let button2 = UIButton()
//        button2.setTitle("btn 2", for: .normal)
//        button2.backgroundColor = UIColor.gray
//        button2.translatesAutoresizingMaskIntoConstraints = false
//        button2.layer.borderWidth = 1.0
//        button2.isHidden = false
//        button2.titleLabel?.text = ""

//        let button3 = UIButton()
//        button3.setTitle("btn 3", for: .normal)
//        button3.backgroundColor = UIColor.brown
//        button3.translatesAutoresizingMaskIntoConstraints = false
//        button3.layer.borderWidth = 1.0
//        button3.isHidden = false
//        button3.titleLabel?.text = ""
        
//        let button4 = UIButton()
//        button4.setTitle("btn 4", for: .normal)
//        button4.backgroundColor = UIColor.green
//        button4.translatesAutoresizingMaskIntoConstraints = false
//        button4.layer.borderWidth = 1.0
//        button4.isHidden = false
//        button4.titleLabel?.text = ""

//        track4StackView.alignment = .fill
  //      track4StackView.distribution = .fillEqually
    //    track4StackView.spacing = 0.0

        // from: https://stackoverflow.com/a/58548253
//        let childStackView = UIStackView()
//        childStackView.axis = .horizontal
//        childStackView.spacing = 0.0
//        childStackView.alignment = .fill
//        childStackView.distribution = .fillEqually
//        childStackView.contentMode = .scaleToFill
//        childStackView.autoresizesSubviews = true
//        childStackView.backgroundColor = .yellow
//
        //track4StackView.addArrangedSubview(childStackView)
//        track4StackView.alignment = .fill
//        track4StackView.distribution = .fillEqually
//        track4StackView.spacing = 0
        
        //childStackView.translatesAutoresizingMaskIntoConstraints = false
        //childStackView.heightAnchor.constraint(equalTo: track4StackView.heightAnchor)
        
//        track0StackView.addArrangedSubview(button)
       // button.widthAnchor.constraint(equalTo: track4StackView.widthAnchor).isActive = true
//        track4StackView.addArrangedSubview(button2)
//        track4StackView.addArrangedSubview(button3)
//        track4StackView.addArrangedSubview(button4)
     
        
        // stackoverflow end
        
        
        trackButtonMatrix = [track0Buttons, track1Buttons, track2Buttons, track3Buttons]
        
        muteButtons = [mute0Button, mute1Button, mute2Button, mute3Button]
        trackSettingsButtons = [settingsButton0, settingsButton1, settingsButton2, settingsButton3 ]
        stepperButtons = [/*stepper0Button, stepper1Button, stepper2Button, stepper3Button */]
        stepperViews = [/*stepper0View, stepper1View, stepper2View, stepper3View */]
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
//            button.backgroundColor = K.Color.muteButtonColor
//            button.layer.borderColor = K.Color.muteButtonBorderColor.cgColor
//            button.layer.borderWidth = 1.0
            button.tintColor = K.Color.orange
            button.isHidden = false
            //            button.titleLabel?.text = "AA"
           // button.setTitleColor(K.Color.black, for: .normal)
            button.layer.cornerRadius = 5
            // button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.tag = index
           // button.widthAnchor.constraint(equalToConstant: 35).isActive = true
          //  button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
        }
        // TRACK SETTINGS buttons:
        //
        for (index, button) in trackSettingsButtons.enumerated() {
            //print("Index: \(index)")
//            button.backgroundColor = K.Color.muteButtonColor
            //button.layer.borderColor = K.Color.muteButtonBorderColor.cgColor
//            button.layer.borderWidth = 1.0
            button.tintColor = K.Color.white
            button.isHidden = false
            //            button.titleLabel?.text = "AA"
           // button.setTitleColor(K.Color.black, for: .normal)
            //button.layer.cornerRadius = 5
            // button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.tag = index
            //button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
            //button.imageView?.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
           // button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            //button.imageView?.contentMode = .scaleAspectFit
            //button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            //button.imageEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

           // button.imageView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
           // button.imageView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
           // button.widthAnchor.constraint(equalToConstant: 35).isActive = true
           // button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
        }
        
        
        //
        // MARK: - Cells:
        //
        
        // Style & show all step/"Cell" buttons:
        //
        let allButtons = track0Buttons + track1Buttons + track2Buttons + track3Buttons
        for (index, button) in allButtons.enumerated() {
            //print("Index: \(index)")
            //button.backgroundColor = .none
            button.layer.borderColor = K.Color.blue_brighter.cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = false
            button.titleLabel?.text = ""
            button.layer.cornerRadius = 5
            button.tag = index
           //button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            // button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
          //  if let superview = button.superview {
                //button.topAnchor.constraint(equalTo: superview.topAnchor, constant: 10).isActive = true
               // button.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 20).isActive = true
          //  }
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
        partSegmentedControl.selectedSegmentTintColor = K.Color.orange
        partSegmentedControl.backgroundColor = K.Color.blue
        
        partSegmentedControl.tintColor = K.Color.blue
        // partSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: K.Color.white], for: .selected)
        //partSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: K.Color.white], for: .selected)
        //partSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24),
                NSAttributedString.Key.foregroundColor: K.Color.blue_brighter
            ]
            , for: .normal
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24),
                NSAttributedString.Key.foregroundColor: K.Color.blue
            ]
            , for: .selected
        )
       
        
        // SOFT MODE button:
        //
      softModeButton.setTitleColor(K.Color.blue, for: .normal)
        softModeButton.backgroundColor = K.Color.orange
        softModeButton.layer.cornerRadius = 0.125 * softModeButton.bounds.size.width
       softModeButton.tintColor = K.Color.blue
        softModeButton.titleLabel?.textColor = K.Color.blue

        
        // DELETE button:
        //
       deleteButton.setTitleColor(K.Color.blue, for: .normal)
        deleteButton.backgroundColor = K.Color.orange
        deleteButton.layer.cornerRadius = 0.125 * deleteButton.bounds.size.width
        deleteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deleteButton.tintColor = K.Color.blue
        deleteButton.titleLabel?.textColor = K.Color.blue

        
        // COPY button:
        //
        copyButton.setTitleColor(K.Color.blue, for: .normal)
        copyButton.backgroundColor = K.Color.orange
        copyButton.layer.cornerRadius = 0.125 * copyButton.bounds.size.width
        copyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        copyButton.tintColor = K.Color.blue
        copyButton.titleLabel?.textColor = K.Color.blue
        
        // CHAIN button:
        //
        chainButton.setTitleColor(K.Color.blue, for: .normal)
        chainButton.backgroundColor = K.Color.orange
        chainButton.layer.cornerRadius = 0.125 * chainButton.bounds.size.width
        chainButton.titleLabel?.adjustsFontSizeToFitWidth = true
        //chainButton.tintColor = K.Color.white
        chainButton.titleLabel?.textColor = K.Color.blue
        chainButton.setTitle(ChainModeNames.OFF.description, for: .normal)

        // TAP button:
        //
        tapButton.setTitleColor(K.Color.blue, for: .normal)
        tapButton.backgroundColor = K.Color.orange
        tapButton.layer.cornerRadius = 0.125 * tapButton.bounds.size.width
        tapButton.tintColor = K.Color.blue
        tapButton.titleLabel?.textColor = K.Color.blue
        
        // BPM picker:
        //
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(90, inComponent: 0, animated: true) // start at 120 bpm
        picker.selectRow(0, inComponent: 1, animated: true) // decimal point
        picker.selectRow(0, inComponent: 2, animated: true) // start at 0 as decimal
        picker.tintColor = K.Color.blue
        picker.backgroundColor = K.Color.orange
        picker.layer.cornerRadius = 0.125 * picker.bounds.size.width
        //picker.pickerTextColor = K.Color.blue
        //picker.setValue(UIColor.yellow, forKeyPath: "textColor")
        
        
        // PLAY button:
        //
        playPauseButton.setTitleColor(.white, for: .normal)
        playPauseButton.backgroundColor = K.Color.orange
        playPauseButton.layer.cornerRadius = 0.125 * playPauseButton.bounds.size.width
        playPauseButton.tintColor = K.Color.blue
        playPauseButton.titleLabel?.textColor = K.Color.blue
        
       
        
    }
}

extension UIPickerView {
@IBInspectable var pickerTextColor:UIColor? {
    get {
        return self.pickerTextColor
    }
    set {
        self.setValue(newValue, forKeyPath: "textColor")
    }
}}
