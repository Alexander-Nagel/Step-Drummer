//
//  Sound.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 12.05.21.
//

import Foundation
import AVFoundation

struct FileNames {
    var normal = [String]()
    var soft = [String]()
}

struct Files {
    var normal = [AVAudioFile]()
    var soft = [AVAudioFile]()
}

//struct SoundBuffers {
//    var normal = [AVAudioPCMBuffer]()
//    var soft = [AVAudioPCMBuffer]()
//}

//
// SoundBuffers
//
// Number of soundBuffers = number of players (constant value of 4 - as for now)
// 
//
struct SoundBuffers {
    var normal = [[AVAudioPCMBuffer]]() // soundBuffer.normal[0] : [AVAudioPCMBuffer] = first player's array of maximum 16 values for each duration, depending on the file length. max duration = ceil (fileLengthInSamples / samplesOfa16thNote)
    var soft = [[AVAudioPCMBuffer]]()
    var lengthOfBufferInWholeCells = [Int]() // if a sound file is 8000 samples long, and a 16th note duration is 5512,5 samples (e.g. @ 120 bpm), the buffer will be 2 16th notes long = 11.025 samples, so the whole file fits in. lengthOfBufferInWholeCells for this file will be 2.
}

//
//struct Sounds {
//    var fileNames: FileNames
//    var files: Files?
//}
