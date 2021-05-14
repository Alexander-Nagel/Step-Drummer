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
    var volume: Double = 1
    var muted: Bool = false
    var soloed: Bool = false
    var isReverbOn = true
    var isDelayOn = true
    var reverbMix = 0.5
    var delayMix = 0.5
    
    var cells = [Cell]()
    var patterns = Patterns()
    
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
    var patterns = Patterns()
    var activePattern = 0
    
    mutating func loadPattern(number: Int) {
        
        tracks[0].numberOfCellsActive = patterns.kick[number].length
        tracks[0].cells = patterns.kick[number].data
        
        tracks[1].numberOfCellsActive = patterns.snare[number].length
        tracks[1].cells = patterns.snare[number].data
        
        tracks[2].numberOfCellsActive = patterns.closed_hihat[number].length
        tracks[2].cells = patterns.closed_hihat[number].data
        
        tracks[3].numberOfCellsActive = patterns.open_hihat[number].length
        tracks[3].cells = patterns.open_hihat[number].data
    }
    
    mutating func saveToPattern(number: Int) {
        
        patterns.kick[number].length = tracks[0].numberOfCellsActive
        patterns.kick[number].data = tracks[0].cells
        
        patterns.snare[number].length = tracks[1].numberOfCellsActive
        patterns.snare[number].data = tracks[1].cells
        
        patterns.closed_hihat[number].length = tracks[2].numberOfCellsActive
        patterns.closed_hihat[number].data = tracks[2].cells
        
        patterns.open_hihat[number].length = tracks[3].numberOfCellsActive
        patterns.open_hihat[number].data = tracks[3].cells
    }
    
    
    
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
    //
    // Computes duration in samples of 16th note depending on BPM / samplerate (44100 kHz)
    //
    func durationOf16thNoteInSamples(forTrack track: Int) -> Double {
        let activeCells = Double(tracks[track].numberOfCellsActive)
        let bpm = (tempo?.bpm)!
        let sampleRate = Double(K.Sequencer.sampleRate)
        
        let length = (4.0 / activeCells) * (60.0 / bpm) * sampleRate
        return length
    }
    
    func rubbish(a: Int, b: Int) -> Int {
        return a + b
    }
    
}

struct Pattern {
    var length: Int
    var data: [Cell]
}
