//
//  Sequencer.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 05.05.21.
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

enum Cell {
    case OFF
    case SOFT
    case ON
}

struct Track {
    
    var numberOfCellsActive: Int = 16

    var selectedSound: String?
    var volume: Int = 1
    var muted: Bool = false
    var soloed: Bool = false
    var cells = [Cell]()
    
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

struct Sequencer {
    
    var tracks = [Track]()
    
    var tempo: Tempo?
 
    init() {
        for _ in 0...(K.Sequencer.numberOfTracks-1) {
            let track = Track()
            self.tracks.append(track)
        }
    }
    
    func printTracks() {
        for track in self.tracks {
            for cell in track.cells {
                print("\(cell) ", terminator: "")
            }
            print()
        }
    }
    
    func getPeriodLengthInSamples(forTrack track: Int) -> Double {
        let activeCells = Double(tracks[track].numberOfCellsActive)
        let bpm = (tempo?.bpm)!
        let sampleRate = Double(K.Sequencer.sampleRate)
        
        let length = (4.0 / activeCells) * (60.0 / bpm) * sampleRate
        return length
    }
}
