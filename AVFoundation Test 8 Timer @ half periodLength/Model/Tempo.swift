//
//  Tempo.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 18.05.21.
//

import Foundation

struct Tempo {
    var bpm: Double = 120
    var sampleRate: Double
    var oneBeatInSamples: Double {
        get {
            60 / self.bpm * self.sampleRate
        }
    }
    var oneBeatInSeconds: Double {
        get {
            60 / self.bpm
        }
    }
    
    var fourBeatsInSamples: Double {
        get {
            60 / self.bpm * self.sampleRate * 4.0
        }
    
    }
    var fourBeatsInSeconds: Double {
        get {
            60 / self.bpm * 4.0
        }
    
    }

}
