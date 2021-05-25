//
//  ArrayOfCell2ArrayOfString.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 25.05.21.
//

import Foundation
import RealmSwift

func stringListToCellArray(stringList: List<String>) -> [Cell] {
   
    var cellArray = [Cell]()
    for i in 0...(stringList.count-1) {
        let string = stringList[i]
        switch string {
        case "ON":
            cellArray.append(.ON)
        case "OFF":
            cellArray.append(.OFF)
        case "SOFT":
            cellArray.append(.SOFT)
        default:
            print("Pattern contains strange things!")
        }
    }
    print(stringList, "converted to: ", cellArray)
    return cellArray
}

