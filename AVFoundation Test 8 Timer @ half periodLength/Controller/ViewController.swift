// uing timer to schedule buffers
// https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer


import UIKit
import AVFoundation

struct Tempo {
    var bpm: Double = 120
    var sampleRate: Double
    var periodLengthInSamples: Double {
        get {
            60 / self.bpm * self.sampleRate
        }
    }
}

fileprivate let DEBUG = false

class ViewController: UIViewController{
    
    private var engine = AVAudioEngine()
    private var player = AVAudioPlayerNode()
    private var mixer = AVAudioMixerNode()
    
    private var bpmDetector = BpmDetector()

    private let fileName1 = "sound1.wav"
    private let fileName2 = "sound2.wav"
    private let fileName3 = "pcm stereo 16 bit 44.1kHz.wav"
    private var file1: AVAudioFile! = nil
    private var file2: AVAudioFile! = nil
    private var file3: AVAudioFile! = nil
    private var buffer1: AVAudioPCMBuffer! = nil
    private var buffer2: AVAudioPCMBuffer! = nil
    private var buffer3: AVAudioPCMBuffer! = nil
    private let sampleRate: Double = 44100
    private var tempo: Tempo?
  
    private var timerEventCounter: Int = 1
    private var currentBeat: Int = 1
    
    private enum MetronomeState {case run; case stop}
    private var state: MetronomeState = .stop
    
    private var timer: Timer! = nil
    private var interruptBuffers = false
    private var needsFileScheduled: Bool = true
  
    private let pickerLeftInts = 30...300 // 271 elements
    private let pickerRightDecimals = 0...9 // 10 elements
    private var pickedLeft: Int = 120
    private var pickedRight: Int = 0
    
    @IBOutlet weak var beat1Label: UILabel!
    @IBOutlet weak var beat2Label: UILabel!
    @IBOutlet weak var beat3Label: UILabel!
    @IBOutlet weak var beat4Label: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    private var beatLabels: [UILabel] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()

        tempo = Tempo(bpm: 120, sampleRate: sampleRate)
        
        // Connect data:
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(90, inComponent: 0, animated: true) // start at 120 bpm
        picker.selectRow(0, inComponent: 1, animated: true) // decimal point
        picker.selectRow(0, inComponent: 2, animated: true) // start at 0 as decimal

        
        beatLabels = [beat1Label, beat2Label, beat3Label, beat4Label]
        stepper.minimumValue = 30
        stepper.maximumValue = 300
        stepper.stepValue = 1
        stepper.value = tempo!.bpm
        bpmLabel.text = String(tempo!.bpm)
        
        loadBuffers()
        
        //
        // MARK: Configure + start engine
        //
        engine.attach(player)
        //engine.attach(player2)
        engine.connect(player, to: engine.mainMixerNode, format: file1.processingFormat)
        //engine.connect(player2, to: engine.mainMixerNode, format: file2.processingFormat)
        engine.prepare()
        do { try engine.start() } catch { print(error) }
        
        preScheduleFirstBuffer()

        
    }
    
    func loadBuffers() {
        
        //
        // MARK: Loading buffer1
        //
        let path1 = Bundle.main.path(forResource: fileName1, ofType: nil)!
        let url1 = URL(fileURLWithPath: path1)
        do {file1 = try AVAudioFile(forReading: url1)
            buffer1 = AVAudioPCMBuffer(
                pcmFormat: file1.processingFormat,
                frameCapacity: AVAudioFrameCount(tempo!.periodLengthInSamples))
            try file1.read(into: buffer1!)
            buffer1.frameLength = AVAudioFrameCount(tempo!.periodLengthInSamples)
        } catch { print("Error loading buffer1 \(error)") }
        
        //
        // MARK: Loading buffer2
        //
        let path2 = Bundle.main.path(forResource: fileName2, ofType: nil)!
        let url2 = URL(fileURLWithPath: path2)
        do {file2 = try AVAudioFile(forReading: url2)
            buffer2 = AVAudioPCMBuffer(
                pcmFormat: file2.processingFormat,
                frameCapacity: AVAudioFrameCount(tempo!.periodLengthInSamples))
            try file2.read(into: buffer2!)
            buffer2.frameLength = AVAudioFrameCount(tempo!.periodLengthInSamples)
        } catch { print("Error loading buffer2 \(error)") }
        
        //
        // MARK: Loading buffer3 (8 seconds!)
        //
        let path3 = Bundle.main.path(forResource: fileName3, ofType: nil)!
        let url3 = URL(fileURLWithPath: path3)
        do {file3 = try AVAudioFile(forReading: url3)
            buffer3 = AVAudioPCMBuffer(
                pcmFormat: file3.processingFormat,
                frameCapacity: AVAudioFrameCount(file3.length))
            try file3.read(into: buffer3!)
            buffer3.frameLength = AVAudioFrameCount(file3.length)
        } catch { print("Error loading buffer2 \(error)") }
        
    }
    
    //
    // MARK: Tap button pressed
    //
    
    @IBAction func tappedPressed(_ sender: UIButton) {
        
        tapButton.flash(intervalDuration: 0.05, intervals: 1)
        
        let newTempo = bpmDetector.tapReceived()
        if DEBUG {print("newTempo: \(newTempo)")}
        
        if newTempo >= 30.0 && newTempo <= 300.0 {
            tempoChanged(to: newTempo)
            
            print(newTempo)
            
            let leftSide = floor(newTempo)
            let rightSide = (newTempo - leftSide) * 10
            
            print("\(leftSide) \(rightSide)")
            
            picker.selectRow(Int(leftSide) - 30, inComponent: 0, animated: true) //
            picker.selectRow(0, inComponent: 1, animated: true) // decimal point
            picker.selectRow(Int(rightSide), inComponent: 2, animated: true) // start at 0 as decimal
            
            
            
            
        }
    }
    
    
    //
    // MARK: Stepper action
    //
    @IBAction func stepperPressed(_ sender: UIStepper) {

        tempoChanged(to: stepper.value)
        
    }
    
    //
    // MARK: Play / Pause toggle action
    //
    @IBAction func buttonPresed(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if state == .run {
            
            //
            // Stop!
            //
            
            state = .stop
            playPauseButton.setImage(UIImage(systemName: K.Image.playImage), for: .normal)
            for label in self.beatLabels {label.text = ""}
            
            timer.invalidate()
            timerEventCounter = 1
            currentBeat = 1
            
            preScheduleFirstBuffer()
            
        } else {
            
            //
            // Go!
            //
            state = .run
            playPauseButton.setImage(UIImage(systemName: K.Image.pauseImage), for: .normal)

            
            scheduleFirstBuffer()
            
            startTimer()
            
        }
    }
    
    fileprivate func startTimer() {
        
        if DEBUG {
            print("# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  ")
            print()
        }
        
        // trigger 2 timer events per period
        let timerIntervallInSamples = self.tempo!.periodLengthInSamples / (2 * sampleRate)
        
        timer = Timer.scheduledTimer(withTimeInterval: timerIntervallInSamples, repeats: true) { timer in
            
            //
            // Compute & dump debug values
            //
            // Values at begin of timer event
            var currentTime = round(self.player.currentTimeInSeconds, toDigits: 3)
            if DEBUG {
                print("@start \tbpm: \(self.tempo!.bpm)\ttimerEvent: \(self.timerEventCounter) \tbeat: \(self.currentBeat) \tcurrTime: \(currentTime)")
            }
            
            //
            // Schedule next buffer at 1st, 3rd, 5th & 7th timerEvent
            //
            var bufferScheduled: String = "" // only needed for debugging / console output
            switch self.timerEventCounter {
            case 7:
                
                //
                // Schedule main sound
                //
                self.player.scheduleBuffer(self.buffer1, at:nil, options: [], completionHandler: nil)
                bufferScheduled = "buffer1"
                
            case 1, 3, 5:
                
                //
                // Schedule subdivision sound
                //
                self.player.scheduleBuffer(self.buffer2, at:nil, options: [], completionHandler: nil)
                bufferScheduled = "buffer2"
                
            default:
                bufferScheduled = ""
            }
            
            //
            // Display current beat & increase currentBeat (1...4) at 2nd, 4th, 6th & 8th timerEvent
            //
            if self.timerEventCounter % 2 == 0 {
                for label in self.beatLabels {label.text = ""}
                DispatchQueue.main.async {
                    self.beatLabels[self.currentBeat-1].text = String(self.currentBeat)
                    self.beatLabels[self.currentBeat-1].flash(intervalDuration: 0.05, intervals: 2)
                }
                self.currentBeat += 1; if self.currentBeat > 4 {self.currentBeat = 1}
            }
            
            //
            // Increase timerEventCounter, two events per beat.
            //
            self.timerEventCounter += 1; if self.timerEventCounter > 8 {self.timerEventCounter = 1}
            
            
           
            // Values at end of timer event
            if DEBUG {
                currentTime = round(self.player.currentTimeInSeconds, toDigits: 3)
                print("@end \tbpm: \(self.tempo!.bpm)\ttimerEvent: \(self.timerEventCounter) \tbeat: \(self.currentBeat) \tcurrTime: \(currentTime) \t\(bufferScheduled)")
                print()
            }
            
        }
    }
    
    private func scheduleFirstBuffer() {
        
//        player.stop()
//
//        //
//        // pre-load accented main sound (for beat "1") before trigger starts
//        //
//        player.scheduleBuffer(buffer1, at: nil, options: [], completionHandler: nil)
        player.play()
        beat1Label.text = String(currentBeat)
        beatLabels[currentBeat-1].flash(intervalDuration: 0.05, intervals: 2)
        //print("currentBeat = \(currentBeat)")
    }
 
    private func preScheduleFirstBuffer() {
        
        player.stop()
        player.scheduleBuffer(buffer1, at: nil, options: [], completionHandler: nil)
        player.prepare(withFrameCount: AVAudioFrameCount(tempo!.periodLengthInSamples))
        
    }
}

//
// MARK: UIPicker Data Source & Delegate
//
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 271
        } else if component == 1{
            return 1
        } else {
            return 10
        }
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(Array(pickerLeftInts)[row])"
        } else if component == 1 {
            return "."
        } else {
            return "\(Array(pickerRightDecimals)[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 60
        } else if component == 1 {
            return 15
        } else if component == 2 {
            return 60
        } else {
            print("This is quite unlikely to happen.")
            return 30
        }
    }
    
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("row: \(row) component: \(component)")
        
        switch component {
        case 0:
            pickedLeft = Array(pickerLeftInts)[row]
        case 1:
            print("Nothing happens when picking the decimals point.")
        case 2:
            pickedRight = Array(pickerRightDecimals)[row]
        default:
            print("This happens almost never.")
        }
        let newTempo = Double(pickedLeft) + Double(pickedRight) / 10.0
        if DEBUG {print(newTempo)}
        tempoChanged(to: newTempo)
        
    }
    
    private func tempoChanged(to newTempo: Double) {
        
        //
        // Set new tempo, display value, load new buffers
        //
        tempo?.bpm = newTempo
        bpmLabel.text = String(tempo!.bpm)
        loadBuffers()
        for label in self.beatLabels {label.text = ""}

        //
        // Stop timer
        //
        if timer != nil {
            timer.invalidate()
        }
        timerEventCounter = 1
        currentBeat = 1
        
        //
        //  Start again
        //
        if state == .run {
            scheduleFirstBuffer()
            startTimer()
        }
        
        
    }
    
}


