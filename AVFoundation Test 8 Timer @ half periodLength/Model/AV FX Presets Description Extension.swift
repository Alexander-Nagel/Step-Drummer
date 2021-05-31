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
    var description: String {
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

extension AVAudioUnitDistortionPreset {
    var description: String {
        switch self.rawValue {
        case 0: return "Drums Bit Brush"
        case 1: return "Drums Buffer Beats"
        case 2: return "Drums LoFi"
        case 3: return "Multi Broken Speaker"
        case 4: return "Multi Cellphone Convert"
        case 5: return "Multi Decimated 1"
        case 6: return "Multi Decimated 2"
        case 7: return "Multi Decimated 3"
        case 8: return "Multi Decimated 4"
        case 9: return "Multi Distorted Funk"
        case 10: return "Multi Distorted Cubed"
        case 11: return "Multi Distorted Squared"
        case 12: return "Multi Echo 1"
        case 13: return "Multi Echo 2"
        case 14: return "Multi Echo Tight 1"
        case 15: return "Multi Echo Tight 2"
        case 16: return "Multi Everything is Broken"
        case 17: return "Speech Alien Chatter"
        case 18: return "Speech Cosmic Interference"
        case 19: return "Speech Golden Pi"
        case 20: return "Speech Radio Tower"
        case 21: return "Speech Waves"
        default: return ""
        }
    }
}
