//
//  Track.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 18.05.21.
//

import Foundation

struct Track {
    
    var numberOfCellsActive: Int = 16
    var selectedSound: String?
    //var volume: Double = 1
    var muted: Bool = false
    var soloed: Bool = false
    var isReverbOn = true
    var isDelayOn = true
    var reverbMix = 0.0
    var delayMix = 0.0
    
    var cells = [Cell]()
    var patterns = DefaultPatterns()
    
    init() {
        for _ in 0...(K.Sequencer.numberOfCellsPerTrack-1) {
            let cell = Cell.OFF
            self.cells.append(cell)
        }
    }
    func getActiveCells() -> [Cell] {
        
        var output = [Cell]()
        for i in 0...(numberOfCellsActive - 1) {
            output.append(cells[i])
        }
        return output
    }
}
