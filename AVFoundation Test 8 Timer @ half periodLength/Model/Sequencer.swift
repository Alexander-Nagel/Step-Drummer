//
//  Sequencer.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 05.05.21.
//

import Foundation
import AVFoundation

struct Sequencer {
    
    var bpmDetector = BpmDetector()
    
    var displayedTracks = [Track]()
    var defaultPatterns = DefaultPatterns()
    var parts = [PartNames.A: Part(), PartNames.B: Part(), PartNames.C: Part(), PartNames.D: Part()]
    var activePart: PartNames = .A
    var chainMode: ChainModeNames = .OFF
    var tempo: Tempo?
    
    internal var cellsToWaitBeforeReschedulingArray = Array(repeating: 0, count: K.Sequencer.numberOfTracks)
    
    var engine = AVAudioEngine()
    var players = [AVAudioPlayerNode(), AVAudioPlayerNode(),
                   AVAudioPlayerNode(), AVAudioPlayerNode()]
    var guidePlayer = AVAudioPlayerNode()
    var reverbs = [AVAudioUnitReverb(), AVAudioUnitReverb(),
                   AVAudioUnitReverb(), AVAudioUnitReverb()]
    var delays = [AVAudioUnitDelay(), AVAudioUnitDelay(),
                  AVAudioUnitDelay(), AVAudioUnitDelay()]
    var distortions = [AVAudioUnitDistortion(), AVAudioUnitDistortion(), AVAudioUnitDistortion(), AVAudioUnitDistortion()]
    var mixer = AVAudioMixerNode()
    
    let fileNameSilence = "silence.wav"
    
    var selectedSounds: [String]
    var volumes: [Float] = Array(repeating: 0.5, count: K.Sequencer.numberOfTracks)
    
    var distortionWetDryMixes: [Float] = Array(repeating: 0, count: K.Sequencer.numberOfTracks) // range: 0...100
    var distortionPreGains: [Float] = Array(repeating: 6, count: K.Sequencer.numberOfTracks) // range: -80...20
    var distortionPresets: [AVAudioUnitDistortionPreset] = Array(repeating: AVAudioUnitDistortionPreset.drumsBitBrush, count: K.Sequencer.numberOfTracks)
    
    var reverbWetDryMixes: [Float] = Array(repeating: 0.0, count: K.Sequencer.numberOfTracks) // range: 0...100
    var reverbTypes: [Int] = Array(repeating: 1, count: K.Sequencer.numberOfTracks)
    
    var delayWetDryMixes: [Float] = Array(repeating: 0.0, count: K.Sequencer.numberOfTracks) // range: 0...100
    var delayFeedbacks: [Float] = Array(repeating: 50.0, count: K.Sequencer.numberOfTracks) // range: -100...100 %
    var delayTimes: [Double] = Array(repeating: 1.0, count: K.Sequencer.numberOfTracks) // range: 0...2 seconds
    var delayPresets: [SyncDelay] = Array(repeating: SyncDelay.dottedEighth, count: K.Sequencer.numberOfTracks)
    //var delaySyncOn: [Bool] = Array(repeating: false, count: K.Sequencer.numberOfTracks)
    
    let fileNames = FileNames(
        normal: [
            "BD01.wav",
            "SN01.wav",
            "SN02.wav",
            "CH01.wav",
            "OH01.wav",
            "440KICK1.wav",
            "440SN1.wav",
            "hihat_2154samples.wav",
            "open_hihat_2181samples.wav",
            "440KICK2.wav",
            "440KICK3.wav",
            "440CLAP.wav",
            "440SN2.wav",
            "440SN3.wav",
            "440CLHH.wav",
            "440OHH.wav",
            "440CRASH.wav",
            "440BASS2.wav",
            "SINUS_1sec_44100samples.wav",
            "SINUS_INVERTED_1sec_44100samples.wav"
            
        ],
        soft: [
            "BD01_SOFT.wav",
            "SN01_SOFT.wav",
            "SN02_SOFT.wav",
            "CH01_SOFT.wav",
            "OH01_SOFT.wav",
            "kick_2156samples_SOFT.wav",
            "snare_2152samples_SOFT.wav",
            "hihat_2154samples_SOFT.wav",
            "open_hihat_2181samples_SOFT.wav",
            "kick_2156samples_SOFT.wav",
            "kick_2156samples_SOFT.wav",
            "snare_2152samples_SOFT.wav",
            "snare_2152samples_SOFT.wav",
            "snare_2152samples_SOFT.wav",
            "hihat_2154samples_SOFT.wav",
            "open_hihat_2181samples_SOFT.wav",
            "440CRASH.wav",
            "440BASS2.wav",
            "SINUS_1sec_44100samples.wav",
            "SINUS_INVERTED_1sec_44100samples.wav"
        ])
    
    var files = Files()
    var fileSilence: AVAudioFile! = nil
    
    var soundBuffers = SoundBuffers()
    //var soundBuffer = [SoundBuffers]()
    var silenceBuffers = [AVAudioPCMBuffer]()
    
    var guideBuffer = AVAudioPCMBuffer()
    
    init() {
        for _ in 0...(K.Sequencer.numberOfTracks-1) {
            let track = Track()
            self.displayedTracks.append(track)
        }
        
        tempo = Tempo(bpm: 120, sampleRate: K.Sequencer.sampleRate)
        
        selectedSounds = [
            /* "440OHH.wav",
             "440SN1.wav", */
            "SINUS_1sec_44100samples.wav",
            "SINUS_INVERTED_1sec_44100samples.wav",
            "hihat_2154samples.wav",
            "open_hihat_2181samples.wav"]
        
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
        //  print("BufferDuration: \(round(session.ioBufferDuration, toDigits: 3)) s")
        
        //var mixer = engine.mainMixerNode
        //var input = engine.inputNode
        // var output = engine.outputNode
        let format = reverbs[2].inputFormat(forBus: 0)
        
        engine.attach(players[0])
        engine.attach(players[1])
        engine.attach(players[2])
        engine.attach(players[3])
        engine.attach(guidePlayer)
        
        engine.attach(distortions[0])
        engine.attach(distortions[1])
        engine.attach(distortions[2])
        engine.attach(distortions[3])
        
        engine.attach(delays[0])
        engine.attach(delays[1])
        engine.attach(delays[2])
        engine.attach(delays[3])
        
        engine.attach(reverbs[0])
        engine.attach(reverbs[1])
        engine.attach(reverbs[2])
        engine.attach(reverbs[3])
        
        
        engine.connect(players[0], to: distortions[0], format: format)
        engine.connect(distortions[0], to: delays[0], format: format)
        engine.connect(delays[0], to: reverbs[0], format: format)
        engine.connect(reverbs[0], to: engine.mainMixerNode, format: format)
        
        engine.connect(players[1], to: distortions[1], format: format)
        engine.connect(distortions[1], to: delays[1], format: format)
        engine.connect(delays[1], to: reverbs[1], format: format)
        engine.connect(reverbs[1], to: engine.mainMixerNode, format: format)
        
        engine.connect(players[2], to: distortions[2], format: format)
        engine.connect(distortions[2], to: delays[2], format: format)
        engine.connect(delays[2], to: reverbs[2], format: format)
        engine.connect(reverbs[2], to: engine.mainMixerNode, format: format)
        
        engine.connect(players[3], to: distortions[3], format: format)
        engine.connect(distortions[3], to: delays[3], format: format)
        engine.connect(delays[3], to: reverbs[3], format: format)
        engine.connect(reverbs[3], to: engine.mainMixerNode, format: format)
        
        for i in 0...K.Sequencer.numberOfTracks-1 {
            reverbs[i].loadFactoryPreset(AVAudioUnitReverbPreset(rawValue: reverbTypes[i])!)
            reverbs[i].wetDryMix = reverbWetDryMixes[i]
        }
        
        //
        // Populate delayTimes array with actual times & init to delay units
        //
        for i in 0...(K.Sequencer.numberOfTracks-1) {
            let delayPreset = delayPresets[i]
            if let tempo = tempo?.fourBeatsInSeconds {
                let time = delayPreset.factor * tempo
                delayTimes[i] = time
                //print(time)
                delays[i].delayTime = delayTimes[i]
                delays[i].feedback = delayFeedbacks[i]
                delays[i].wetDryMix = delayWetDryMixes[i]
                // delays[i].lowPassCutoff
            }
        }
        
        //
        // Init distortion units
        //
        for i in 0...(K.Sequencer.numberOfTracks-1) {
            distortions[i].loadFactoryPreset(distortionPresets[i])
            distortions[i].wetDryMix = distortionWetDryMixes[i]
            distortions[i].preGain = distortionPreGains[i]
            
        }
        
        engine.prepare()
        do { try engine.start() } catch { print(error) }
        
        files = Files(normal: Array(repeating: AVAudioFile(), count: fileNames.normal.count),
                      soft: Array(repeating: AVAudioFile(), count: fileNames.normal.count))
        
        //        soundBuffers = SoundBuffers(normal: Array(repeating: AVAudioPCMBuffer(), count: K.Sequencer.numberOfTracks), soft: Array(repeating: AVAudioPCMBuffer(), count: K.Sequencer.numberOfTracks))
        soundBuffers = SoundBuffers(
            normal: Array(repeating: Array(repeating: AVAudioPCMBuffer(), count: 16),
                          count: K.Sequencer.numberOfTracks),
            soft: Array(repeating: Array(repeating: AVAudioPCMBuffer(), count: 16),
                        count: K.Sequencer.numberOfTracks),
            lengthOfBufferInWholeCells: Array(repeating: 0, count: 16))
        
        print("fileNames.normal.count: \(fileNames.normal.count)")
        //silenceBuffers = Array(repeating: AVAudioPCMBuffer(), count: fileNames.normal.count)
        silenceBuffers = Array(repeating: AVAudioPCMBuffer(), count: K.Sequencer.numberOfTracks)
        //        for buffer in silenceBuffers {
        //            print("buffer: \(buffer.frameCapacity)")
        //        }
        
        loadPart(partName: .A)
        
        //print(durationOf16thNoteInSamples(forTrack: 0))
        // print(durationOf16thNoteInSamples(forTrack: 1))
        // print(durationOf16thNoteInSamples(forTrack: 2))
        // print( durationOf16thNoteInSamples(forTrack: 3))
    }
    
    mutating func loadPart(partName: PartNames) {
        
        
        for i in 0...3 {
            if let length = parts[partName]?.patterns[i].length,
               let cells = parts[partName]?.patterns[i].cells {
                displayedTracks[i].numberOfCellsActive = length
                displayedTracks[i].cells = cells
            }
        }
    }
    
    mutating func saveToPart(partName: PartNames) {
        
        for i in 0...3 {
            parts[partName]?.patterns[i].length = displayedTracks[i].numberOfCellsActive
            parts[partName]?.patterns[i].cells = displayedTracks[i].cells
        }
    }
    
    mutating func deletePart(partName: PartNames) {
        
        for i in 0...3 {
            if let length = parts[partName]?.patterns[i].length {
                parts[partName]?.patterns[i].cells = Array(repeating: Cell.OFF, count: length)
            }
        }
        print("Deleted part \(partName)")
    }
    
    mutating func copyActivePart(to partName: PartNames) {
        
        let sourceName = activePart
        let destinationName = partName
        
        parts[destinationName] = parts[sourceName]
    }
    
    func printTracks() {
        for track in self.displayedTracks {
            for cell in track.cells {
                print("\(cell) ", terminator: "")
            }
            print()
        }
    }
    
    mutating func changeTempoAndPrescheduleBuffers(bpm: Double) {
        
        print(#function, "bpm: \(bpm)")
        tempo?.bpm = bpm
        
        for trackIndex in 0...(K.Sequencer.numberOfTracks-1) {
            print("pre-scheduling track \(trackIndex):")
            preScheduleFirstBuffer(forPlayer: trackIndex)
        }
    }
    
    //
    // MARK:- PRE SCHEDULE FIRST BUFFER
    //
    
    //    func preScheduleFirstBuffer(forPlayer selectedPlayer: Int) {
    //
    //        print(#function)
    //
    //        // printFrameLengths()
    //
    //        players[selectedPlayer].stop()
    //        if displayedTracks[selectedPlayer].cells[0] == .ON {
    //            //
    //            // Schedule sound
    //            //
    //            players[selectedPlayer].scheduleBuffer(soundBuffers.normal[selectedPlayer], at: nil, options: [], completionHandler: nil)
    //        } else {
    //            //
    //            // Schedule silence
    //            //
    //            print("selectedPlayer: \(selectedPlayer)")
    //            print("players[selectedPlayer]: \(players[selectedPlayer])")
    //            print("silenceBuffers[selectedPlayer]: \(silenceBuffers[selectedPlayer])")
    //
    //            players[selectedPlayer].scheduleBuffer(silenceBuffers[selectedPlayer], at: nil, options: [], completionHandler: nil)
    //        }
    //        players[selectedPlayer].prepare(withFrameCount: AVAudioFrameCount(durationOf16thNoteInSamples(forTrack: selectedPlayer)))
    //    }
    
    //
    // MARK:- PRE SCHEDULE FIRST BUFFER - NEW!!!
    //


    internal mutating func preScheduleFirstBuffer(forPlayer selectedPlayer: Int) {
        
        print(#function, "player: \(selectedPlayer)")

        
        // printFrameLengths()
        players[selectedPlayer].stop()
        
        
        //
        // Compute distance to next .ON
        //
        
        let lengthToSchedule = computeLengthToSchedule(nextStepIndex: 0, timerIndex: selectedPlayer)
        print("|   PRE SCHED\n")
        //
        // scheduleBuffer
        //
        let indexToSchedule = lengthToSchedule - 1
        
        if displayedTracks[selectedPlayer].cells[0] == .ON {
            //
            // Schedule .ON sound
            //
            players[selectedPlayer].scheduleBuffer(soundBuffers.normal[selectedPlayer][indexToSchedule], at: nil, options: [], completionHandler: nil)
        } else if displayedTracks[selectedPlayer].cells[0] == .SOFT {
            //
            // Schedule .SOFT sound
            //
            players[selectedPlayer].scheduleBuffer(soundBuffers.soft[selectedPlayer][indexToSchedule], at: nil, options: [], completionHandler: nil)
        } else {
            //
            // Schedule silence
            //
            print("|   selectedPlayer: \(selectedPlayer)")
            print("|   players[selectedPlayer]: \(players[selectedPlayer])")
            print("|   silenceBuffers[selectedPlayer]: \(silenceBuffers[selectedPlayer])")
            
            players[selectedPlayer].scheduleBuffer(silenceBuffers[selectedPlayer], at: nil, options: [], completionHandler: nil)
            cellsToWaitBeforeReschedulingArray[selectedPlayer] = 0
        }
        
        
        
        
        
        
        
//        if displayedTracks[selectedPlayer].cells[0] == .ON {
//            //
//            // Schedule sound
//            //
//            players[selectedPlayer].scheduleBuffer(soundBuffers.normal[selectedPlayer] [0], at: nil, options: [], completionHandler: nil)
//        } else {
//            //
//            // Schedule silence
//            //
//            print("selectedPlayer: \(selectedPlayer)")
//            print("players[selectedPlayer]: \(players[selectedPlayer])")
//            print("silenceBuffers[selectedPlayer]: \(silenceBuffers[selectedPlayer])")
//
//            players[selectedPlayer].scheduleBuffer(silenceBuffers[selectedPlayer], at: nil, options: [], completionHandler: nil)
//        }
        
        
        players[selectedPlayer].prepare(withFrameCount: AVAudioFrameCount(durationOf16thNoteInSamples(forTrack: selectedPlayer)))
    }
    
    public mutating func computeLengthToSchedule(nextStepIndex: Int, timerIndex: Int) -> Int{
        
        print(#function, "timer: \(timerIndex), nextStep: \(nextStepIndex)")
        
        //
        // Compute distance to next .ON
        //
        var distance: Int = 1
        var startIndex = nextStepIndex + 1
        if startIndex > displayedTracks[timerIndex].numberOfCellsActive - 1 {startIndex = 0}
        while displayedTracks[timerIndex].cells[startIndex] == .OFF && distance < 16{
            distance += 1
            startIndex += 1
            if startIndex > displayedTracks[timerIndex].numberOfCellsActive - 1 {startIndex = 0}
        }
        print("distance: \(distance)")
        
        let soundFileLengthInCells = soundBuffers.lengthOfBufferInWholeCells[timerIndex]
        print("soundFileLengthInCells: \(soundFileLengthInCells)")
        
        let lengthToSchedule = min(distance, soundFileLengthInCells)
        print("lengthToSchedule: \(lengthToSchedule)")
        
        cellsToWaitBeforeReschedulingArray[timerIndex] = lengthToSchedule - 1
        print("cellsToWaitBeforeRescheduling: \(cellsToWaitBeforeReschedulingArray[timerIndex])")
        
        return lengthToSchedule
        
    }
    
    
    //
    // Computes duration in samples of 16th note depending on BPM / samplerate (44100 kHz)
    //
    func durationOf16thNoteInSamples(forTrack track: Int) -> Double {
        let activeCells = Double(displayedTracks[track].numberOfCellsActive)
        let bpm = (tempo?.bpm)!
        let sampleRate = Double(K.Sequencer.sampleRate)
        
        let length = (4.0 / activeCells) * (60.0 / bpm) * sampleRate
        return length
    }
    
    func rubbish(a: Int, b: Int) -> Int {
        return a + b
    }
}
