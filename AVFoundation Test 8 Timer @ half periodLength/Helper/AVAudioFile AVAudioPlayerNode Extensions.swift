//
//  AVAudioFile AVAudioPlayerNode Extensions.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 29.06.21.
//

import Foundation
import AVFoundation

extension AVAudioFile{

    var duration: TimeInterval{
        let sampleRateSong = Double(processingFormat.sampleRate)
        let lengthSongSeconds = Double(length) / sampleRateSong
        return lengthSongSeconds
    }

}

extension AVAudioPlayerNode{

    var current: TimeInterval{
        if let nodeTime = lastRenderTime,let playerTime = playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / playerTime.sampleRate
        }
        return 0
    }
}
