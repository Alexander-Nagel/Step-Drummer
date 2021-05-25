//
//  ArrayOfCell2ArrayOfString.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 25.05.21.
//

import Foundation

func cellArrayToStringArray(cellArray: [Cell]) -> [String] {
   
    var stringArray = [String]()
    for i in 0...(cellArray.count-1) {
        let cell = cellArray[i]
        switch cell {
        case .ON:
            stringArray.append("ON")
        case .OFF:
            stringArray.append("OFF")
        case .SOFT:
            stringArray.append("SOFT")
        default:
            print("pattern contains strange things!")
        }
    }
    
    print(cellArray, "converted to: ", stringArray)
    return stringArray
}

