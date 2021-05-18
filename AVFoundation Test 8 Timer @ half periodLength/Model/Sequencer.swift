//
//  Sequencer.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 05.05.21.
//

import Foundation
import AVFoundation

struct Sequencer {
    
    var tracks = [Track]()
    var patterns = Patterns()
    var activePattern = 0
    var chainModeABCD = false
    var tempo: Tempo?
    
    var bpmDetector = BpmDetector()
    
    var engine = AVAudioEngine()
    var players = [AVAudioPlayerNode(), AVAudioPlayerNode(),
                   AVAudioPlayerNode(), AVAudioPlayerNode()]
    var guidePlayer = AVAudioPlayerNode()
    var reverbs = [AVAudioUnitReverb(), AVAudioUnitReverb(),
                   AVAudioUnitReverb(), AVAudioUnitReverb()]
    var delays = [AVAudioUnitDelay(), AVAudioUnitDelay(),
                  AVAudioUnitDelay(), AVAudioUnitDelay()]
    var mixer = AVAudioMixerNode()
    
    let fileNameSilence = "silence.wav"
    
    let fileNames = FileNames(
        normal: ["440KICK1.wav",
                 "440SN1.wav",
                 "hihat_2154samples.wav",
                 "440CRASH.wav"],
        soft: ["kick_2156samples_SOFT.wav",
               "snare_2152samples_SOFT.wav",
               "hihat_2154samples_SOFT.wav",
               "open_hihat_2181samples_SOFT.wav"])
    
    var files = Files()
    var fileSilence: AVAudioFile! = nil
    
    var soundBuffers = SoundBuffers()
    var silenceBuffers = [AVAudioPCMBuffer]()
    
    var guideBuffer = AVAudioPCMBuffer()
    
    init() {
        for _ in 0...(K.Sequencer.numberOfTracks-1) {
            let track = Track()
            self.tracks.append(track)
        }
        
        //
        // MARK:- Configure + start engine
        //
        let session = AVAudioSession.sharedInstance()
        do { try session.setCategory(AVAudioSession.Category.playAndRecord) }
        catch { fatalError("Can't set Audio Session category") }
        
        do { try session.setPreferredIOBufferDuration(2e-3) } // about 2,3 ms latency
        //       do { try session.setPreferredIOBufferDuration(2e-2) } //  about 23 ms latency
        catch {
            fatalError("Can't set preferred buffer size")
        }
        print("BufferDuration: \(round(session.ioBufferDuration, toDigits: 3)) s")
        
        //var mixer = engine.mainMixerNode
        //var input = engine.inputNode
        // var output = engine.outputNode
        let format = reverbs[2].inputFormat(forBus: 0)
        
        engine.attach(players[0])
        engine.attach(players[1])
        engine.attach(players[2])
        engine.attach(players[3])
        engine.attach(guidePlayer)
        
        engine.attach(reverbs[0])
        engine.attach(reverbs[1])
        engine.attach(reverbs[2])
        engine.attach(reverbs[3])
        
        engine.attach(delays[0])
        engine.attach(delays[1])
        engine.attach(delays[2])
        engine.attach(delays[3])
        
        engine.connect(players[0], to: delays[0], format: format)
        engine.connect(delays[0], to: reverbs[0], format: format)
        engine.connect(reverbs[0], to: engine.mainMixerNode, format: format)
        
        engine.connect(players[1], to: delays[1], format: format)
        engine.connect(delays[1], to: reverbs[1], format: format)
        engine.connect(reverbs[1], to: engine.mainMixerNode, format: format)
        
        engine.connect(players[2], to: delays[2], format: format)
        engine.connect(delays[2], to: reverbs[2], format: format)
        engine.connect(reverbs[2], to: engine.mainMixerNode, format: format)
        
        engine.connect(players[3], to: delays[3], format: format)
        engine.connect(delays[3], to: reverbs[3], format: format)
        engine.connect(reverbs[3], to: engine.mainMixerNode, format: format)
        
        reverbs[0].loadFactoryPreset(.mediumHall)
        reverbs[0].wetDryMix = 0
        
        reverbs[1].loadFactoryPreset(.mediumHall)
        reverbs[1].wetDryMix = 0
        
        reverbs[2].loadFactoryPreset(.mediumHall)
        reverbs[2].wetDryMix = 0
        
        reverbs[3].loadFactoryPreset(.mediumHall)
        reverbs[3].wetDryMix = 0
        
        delays[0].delayTime = 0.375
        delays[0].feedback = 5
        delays[0].wetDryMix = 0
        
        delays[1].delayTime = 0.375
        delays[1].feedback = 5
        delays[1].wetDryMix = 0
        
        delays[2].delayTime = 0.375
        delays[2].feedback = 5
        delays[2].wetDryMix = 0
        
        delays[3].delayTime = 0.375
        delays[3].feedback = 5
        delays[3].wetDryMix = 0
        
        engine.prepare()
        do { try engine.start() } catch { print(error) }
        
        files = Files(normal: [AVAudioFile(), AVAudioFile(), AVAudioFile(), AVAudioFile()],
                      soft: [AVAudioFile(), AVAudioFile(), AVAudioFile(), AVAudioFile()])
        soundBuffers = SoundBuffers(normal: [AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer()], soft: [AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer()])
        
        silenceBuffers = [AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer()]
        
        tempo = Tempo(bpm: 120, sampleRate: K.Sequencer.sampleRate)
        loadPattern(number: 0)
        
        print(durationOf16thNoteInSamples(forTrack: 0))
        print(durationOf16thNoteInSamples(forTrack: 1))
        print(durationOf16thNoteInSamples(forTrack: 2))
        print( durationOf16thNoteInSamples(forTrack: 3))
      
        
    }
    
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
