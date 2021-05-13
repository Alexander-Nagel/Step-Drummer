

import Foundation
import UIKit

// blau #1B7DFF
// orange #FF914D

//
// Constants
//
// https://coolors.co/6b9080-a4c3b2-cce3de-eaf4f4-f6fff8
//
struct K {
    
    struct Sequencer {
        static let numberOfTracks = 4
        static let numberOfCellsPerTrack = 16
        static let sampleRate = 44100.0
        
        
        
    }
    
    struct BpmDtctr {
        static let bpmArrayMaxSize = 200 // BPM is calculated from the last ... values
        static let tapTolerance = 0.2 // if tap tempo varie more than 20%, a new measurement begins
        static let tapDetectionRange = 40.0...400.0
    }
    
    struct Color {
        
        //https://coolors.co/ff914d-ffad7a-024176-008bb5-00c3da-ffffff
        
        static let orange = UIColor(rgb: 0xFF914D) // Atomic Tangerine
        static let orange_brighter = UIColor(rgb: 0xFFD0B2) // Apricot
        static let blue = UIColor(rgb: 0x024176) // Indigo Dye
        static let blue_brighter = UIColor(rgb: 0x008BB5) // Blue NCS
        static let blue_brighest = UIColor(rgb: 0x00C3DA) // Dark Turquoise
        static let light_gray = UIColor(rgb: 0xEBEBEB) // Light Gray / "Mercury"
        static let white: UIColor = .white
        static let black: UIColor = .black
        
        static let step = orange
        static let step_soft = orange_brighter
        static let stepPlaying = orange_brighter
        
        static let control = blue
        static let controlSelected = blue_brighter
        
        //static let playerButtonColors = [blue, blue, blue, blue]
        
        static let playerButtonBorderColors = [light_gray, light_gray, light_gray, light_gray]
        
        static let muteButtonColor = blue_brighter
        static let muteButtonBorderColor = blue_brighter
        
        static let controlButtonsColor = K.Color.control
        static let controlButtonsSelectedColor = K.Color.controlSelected
        static let playingCellColor: UIColor = orange
//        static let backgroundColor = UIColor(rgb: 0x6B9080) // Wintergreen Dream
//
//        static let majorButtonColor = UIColor(rgb: 0xCCE3dE) // Light Cyan
//        static let majorButtonTextColor: UIColor = .black
//
//        static let minorButtonColor = UIColor(rgb: 0xA4C3B2) // Cambridge Blue
//        static let minorButtonTextColor: UIColor = .black
//
//        static let buttonTextColor: UIColor = .white
//        static let correctButNotChosenButtonTextColor: UIColor = #colorLiteral(red: 0.3251720667, green: 0.8431780338, blue: 0.411704123, alpha: 1)
//        static let wrongButNotChosenButtonTextColor: UIColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
//        static let wrongChosenButtonTextColor: UIColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
//
//        static let chosenRightAnswerColor: UIColor = #colorLiteral(red: 0.3251720667, green: 0.8431780338, blue: 0.411704123, alpha: 1)
//        static let notChosenRightAnswerBGColor: UIColor = #colorLiteral(red: 0.225044248, green: 0.5792186429, blue: 0.2905635965, alpha: 1)
//        static let wrongAnswerColor: UIColor = #colorLiteral(red: 0.9921812415, green: 0.1882499158, blue: 0.2627539337, alpha: 1)
//
//        static let questionMarkColor: UIColor = .white
//        static let questionMarkPlayingColor: UIColor = .black
//
//        static let selectedLabelBgColor: UIColor = .orange
//        static let selectedLabelTextColor: UIColor = .white
//
//        static let settingsTextColor: UIColor = .white
//        static let settingsCellColor = UIColor(rgb: 0xCCE3dE) // Light Cyan
    }
    
//    struct Sound {
//        static let successSound = "SUCCESS"
//        static let failureSound = "FAILURE"
//    }
    
    struct Image {
        static let successImage = "checkmark"
        static let failureImage = "multiply"
        static let questionImage = "questionmark"
        static let playImage = "play"
        static let pauseImage = "pause"
    }
}




