//
//  AVAudioUnitReverbPresets.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 26.05.21.
//

import Foundation
import AVFoundation

enum reverbPresets: Int {
    case smallRoom = 0
    case mediumRoom
    case largeRoom
    case mediumHall
    case largeHall
    case plate
    case mediumChamber
    case largeChamber
    case catherdral
    case largeRoom2
    case mediumHall2
    case mediumHall3
    case largeHall2
    
    var string: String {
        switch self.rawValue {
        case 0: return "Small Room"
        case 1: return "Medium Room"
        case 2: return "Large Room"
        case 3: return "Medium Hall"
        case 4: return "Large Hall"
        case 5: return "Plate"
        case 6: return "Medium Chamber"
        case 7: return "Large Chamber"
        case 8: return "Cathedral"
        case 9: return "Large Room 2"
        case 10: return "Medium Hall 2"
        case 11: return "Medium Hall 3"
        case 12: return "Large Hall 2"
        default: return ""
        }
    }
}

extension AVAudioUnitReverbPreset {
    var string: String {
        switch self.rawValue {
        case 0: return "Small Room"
        case 1: return "Medium Room"
        case 2: return "Large Room"
        case 3: return "Medium Hall"
        case 4: return "Large Hall"
        case 5: return "Plate"
        case 6: return "Medium Chamber"
        case 7: return "Large Chamber"
        case 8: return "Cathedral"
        case 9: return "Large Room 2"
        case 10: return "Medium Hall 2"
        case 11: return "Medium Hall 3"
        case 12: return "Large Hall 2"
        default: return ""
        }
    }
}
