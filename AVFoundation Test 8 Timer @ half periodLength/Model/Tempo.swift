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
    var periodLengthInSamples: Double {
        get {
            60 / self.bpm * self.sampleRate
        }
    }
}
