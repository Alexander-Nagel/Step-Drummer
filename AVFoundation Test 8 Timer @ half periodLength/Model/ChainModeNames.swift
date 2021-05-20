//
//  ChainModeNames.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 19.05.21.
//

import Foundation
enum ChainModeNames: Int, CaseIterable {
    case AB
    case CD
    case ABCD
//    case AD
//    case CB
//    case ABC
    case OFF
    
    var description: String { // needed for button label text
        switch self {
        case .AB: return "AB"
        case .CD: return "CD"
//        case .ABC: return "ABC"
        case .ABCD: return "ABCD"
//        case .AD: return "AD"
//        case .CB: return "CB"
        case .OFF: return "-"
        }
    }
    var first: PartNames? { // to get first part after re-start
        switch self {
        case .AB: return .A
        case .CD: return .C
//        case .ABC: return .A
        case .ABCD: return .A
//        case .AD: return .A
//        case .CB: return .C
        case .OFF: return nil
        }
    }
    
    func next() -> ChainModeNames {
        let currentIndex = self.rawValue
        var nextIndex = currentIndex + 1
        if nextIndex == ChainModeNames.allCases.count {
            nextIndex = 0
        }
        guard let next = ChainModeNames(rawValue: nextIndex) else {
            fatalError("Error iteraing over ChainModeNames!")
        }
        return next
       
    }
}
