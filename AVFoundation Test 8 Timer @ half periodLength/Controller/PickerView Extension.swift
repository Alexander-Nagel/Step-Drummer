//
//  PickerView Extension.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 20.05.21.
//

import UIKit

//
// MARK:- UIPicker Data Source & Delegate
//
extension MainVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 271
        } else if component == 1{
            return 1
        } else {
            return 10
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Arial", size: 25)
            switch component {
            case 0:
                pickerLabel?.textAlignment = .right
            case 1:
                pickerLabel?.textAlignment = .center
            case 2:
                pickerLabel?.textAlignment = .left
            default:
                print("not gonna be the case for sure")
            }
        }
        pickerLabel?.text = pickerDataArray[component][row]
        pickerLabel?.textColor = UIColor(named: "Your Color Name")
        
        return pickerLabel!
    }
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 60
        } else if component == 1 {
            return 15
        } else if component == 2 {
            return 30
        } else {
            print("This is quite unlikely to happen.")
            return 30
        }
    }
    
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("row: \(row) component: \(component)")
        
        switch component {
        case 0:
            pickedLeft = Array(pickerLeftInts)[row]
        case 1:
            print("Nothing happens when picking the decimals point.")
        case 2:
            pickedRight = Array(pickerRightDecimals)[row]
        default:
            print("This happens almost never.")
        }
        let newTempo = Double(pickedLeft) + Double(pickedRight) / 10.0
//        if DEBUG {print(newTempo)}
        seq.tempo?.bpm = newTempo
        
        preScheduleFirstBuffer(forPlayer: 0)
        preScheduleFirstBuffer(forPlayer: 1)
        preScheduleFirstBuffer(forPlayer: 2)
        preScheduleFirstBuffer(forPlayer: 3)
        
        updateUIAfterTempoChange(to: newTempo)
    }
}
