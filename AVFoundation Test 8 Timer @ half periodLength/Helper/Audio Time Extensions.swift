// https://stackoverflow.com/a/58255754/14506724

import AVFoundation

extension AVAudioFile{

    var durationInSeconds: TimeInterval{
        let sampleRateFile = Double(processingFormat.sampleRate)
        let lengthFileSeconds = Double(length) / sampleRateFile
        return lengthFileSeconds
    }
}

extension AVAudioPlayerNode{
    
    var currentTimeInSeconds: TimeInterval{
        if let nodeTime = lastRenderTime,
           let playerTime = playerTime(forNodeTime: nodeTime)
        {
            return Double(playerTime.sampleTime) / playerTime.sampleRate
        }
        return 0
    }
}

// von mir ergänzt 01.05.2021
extension AVAudioPCMBuffer{

    var durationInSeconds: TimeInterval{
        let sampleRateBuffer = Double(format.sampleRate)
        let lengthBufferSeconds = Double(frameLength) / sampleRateBuffer
        return lengthBufferSeconds
    }
}
