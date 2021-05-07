// uing timer to schedule buffers
// https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer


import UIKit
import AVFoundation

fileprivate let DEBUG = true

class ViewController: UIViewController{
    
    private var engine = AVAudioEngine()
    
    private var player0 = AVAudioPlayerNode()
    private var player1 = AVAudioPlayerNode()
    private var player2 = AVAudioPlayerNode()
    private var player3 = AVAudioPlayerNode()
    
    private var players: [AVAudioPlayerNode] = []
    
    private var mixer = AVAudioMixerNode()
    
    private var bpmDetector = BpmDetector()
    
    private let fileName0 = "sound1.wav"
    private let fileName1 = "sound2.wav"
    private let fileName2 = "kick.wav"
    private let fileName3 = "snare.wav"
    private let fileName4 = "hihat.wav"
    private let fileName5 = "open_hihat.wav"
    private let fileNameSilence = "silence.wav"
    
    //    private let fileNameLong = "pcm stereo 16 bit 44.1kHz.wav"
    private var file0: AVAudioFile! = nil
    private var file1: AVAudioFile! = nil
    private var file2: AVAudioFile! = nil
    private var file3: AVAudioFile! = nil
    private var fileSilence: AVAudioFile! = nil
    
    private var buffer0: AVAudioPCMBuffer! = nil
    private var buffer1: AVAudioPCMBuffer! = nil
    private var buffer2: AVAudioPCMBuffer! = nil
    private var buffer3: AVAudioPCMBuffer! = nil
    private var buffer0Silence: AVAudioPCMBuffer! = nil
    private var buffer1Silence: AVAudioPCMBuffer! = nil
    private var buffer2Silence: AVAudioPCMBuffer! = nil
    private var buffer3Silence: AVAudioPCMBuffer! = nil
    
    private var buffers = [AVAudioPCMBuffer]()
    
    //private let sampleRate: Double = 44100
    //private var tempo: Tempo?
    
    private var timerEventCounter0: Int = 1
    private var currentStep0: Int = 1
    private var timerEventCounter1: Int = 1
    private var currentStep1: Int = 1
    private var timerEventCounter2: Int = 1
    private var currentStep2: Int = 1
    private var timerEventCounter3: Int = 1
    private var currentStep3: Int = 1
    
    private enum MetronomeState {case run; case stop}
    private var state: MetronomeState = .stop
    
    //private var timer: Timer! = nil
    
    private var timer0: Timer! = nil
    private var timer1: Timer! = nil
    private var timer2: Timer! = nil
    private var timer3: Timer! = nil
    
    //    private var interruptBuffers = false
    //    private var needsFileScheduled: Bool = true
    //
    private let pickerLeftInts = 30...300 // 271 elements
    private let pickerRightDecimals = 0...9 // 10 elements
    private var pickedLeft: Int = 120
    private var pickedRight: Int = 0
    
    
//    @IBOutlet weak var beat1Label: UILabel!
//    @IBOutlet weak var beat2Label: UILabel!
//    @IBOutlet weak var beat3Label: UILabel!
//    @IBOutlet weak var beat4Label: UILabel!
//    @IBOutlet weak var beat5Label: UILabel!
//    @IBOutlet weak var beat6Label: UILabel!
//    @IBOutlet weak var beat7Label: UILabel!
//    @IBOutlet weak var beat8Label: UILabel!
    
//    @IBOutlet weak var beat1LabelB: UILabel!
//    @IBOutlet weak var beat2LabelB: UILabel!
//    @IBOutlet weak var beat3LabelB: UILabel!
//    @IBOutlet weak var beat4LabelB: UILabel!
//    @IBOutlet weak var beat5LabelB: UILabel!
//    @IBOutlet weak var beat6LabelB: UILabel!
//    @IBOutlet weak var beat7LabelB: UILabel!
//    @IBOutlet weak var beat8LabelB: UILabel!
    
    //
    // player0
    //
    @IBOutlet weak var button0_0: UIButton!
    @IBOutlet weak var button0_1: UIButton!
    @IBOutlet weak var button0_2: UIButton!
    @IBOutlet weak var button0_3: UIButton!
    @IBOutlet weak var button0_4: UIButton!
    @IBOutlet weak var button0_5: UIButton!
    @IBOutlet weak var button0_6: UIButton!
    @IBOutlet weak var button0_7: UIButton!
    @IBOutlet weak var button0_8: UIButton!
    @IBOutlet weak var button0_9: UIButton!
    @IBOutlet weak var button0_10: UIButton!
    @IBOutlet weak var button0_11: UIButton!
    @IBOutlet weak var button0_12: UIButton!
    @IBOutlet weak var button0_13: UIButton!
    @IBOutlet weak var button0_14: UIButton!
    @IBOutlet weak var button0_15: UIButton!
    
    private var track0Buttons: [UIButton] = []
    
    //
    // player1
    //
    @IBOutlet weak var button1_0: UIButton!
    @IBOutlet weak var button1_1: UIButton!
    @IBOutlet weak var button1_2: UIButton!
    @IBOutlet weak var button1_3: UIButton!
    @IBOutlet weak var button1_4: UIButton!
    @IBOutlet weak var button1_5: UIButton!
    @IBOutlet weak var button1_6: UIButton!
    @IBOutlet weak var button1_7: UIButton!
    @IBOutlet weak var button1_8: UIButton!
    @IBOutlet weak var button1_9: UIButton!
    @IBOutlet weak var button1_10: UIButton!
    @IBOutlet weak var button1_11: UIButton!
    @IBOutlet weak var button1_12: UIButton!
    @IBOutlet weak var button1_13: UIButton!
    @IBOutlet weak var button1_14: UIButton!
    @IBOutlet weak var button1_15: UIButton!
    
    private var track1Buttons: [UIButton] = []
    
    //
    // player2
    //
    @IBOutlet weak var button2_0: UIButton!
    @IBOutlet weak var button2_1: UIButton!
    @IBOutlet weak var button2_2: UIButton!
    @IBOutlet weak var button2_3: UIButton!
    @IBOutlet weak var button2_4: UIButton!
    @IBOutlet weak var button2_5: UIButton!
    @IBOutlet weak var button2_6: UIButton!
    @IBOutlet weak var button2_7: UIButton!
    @IBOutlet weak var button2_8: UIButton!
    @IBOutlet weak var button2_9: UIButton!
    @IBOutlet weak var button2_10: UIButton!
    @IBOutlet weak var button2_11: UIButton!
    @IBOutlet weak var button2_12: UIButton!
    @IBOutlet weak var button2_13: UIButton!
    @IBOutlet weak var button2_14: UIButton!
    @IBOutlet weak var button2_15: UIButton!
    
    private var track2Buttons: [UIButton] = []
    
    //
    // player3
    //
    @IBOutlet weak var button3_0: UIButton!
    @IBOutlet weak var button3_1: UIButton!
    @IBOutlet weak var button3_2: UIButton!
    @IBOutlet weak var button3_3: UIButton!
    @IBOutlet weak var button3_4: UIButton!
    @IBOutlet weak var button3_5: UIButton!
    @IBOutlet weak var button3_6: UIButton!
    @IBOutlet weak var button3_7: UIButton!
    @IBOutlet weak var button3_8: UIButton!
    @IBOutlet weak var button3_9: UIButton!
    @IBOutlet weak var button3_10: UIButton!
    @IBOutlet weak var button3_11: UIButton!
    @IBOutlet weak var button3_12: UIButton!
    @IBOutlet weak var button3_13: UIButton!
    @IBOutlet weak var button3_14: UIButton!
    @IBOutlet weak var button3_15: UIButton!
    
    private var track3Buttons: [UIButton] = []
    
    private var trackButtonMatrix: [[UIButton]] = []
    
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    @IBOutlet weak var mute0Button: UIButton!
    @IBOutlet weak var mute1Button: UIButton!
    @IBOutlet weak var mute2Button: UIButton!
    @IBOutlet weak var mute3Button: UIButton!
    
    private var muteButtons: [UIButton] = []
    
    private var controlButtons: [UIView] = []
    
    //private var beatLabels: [UILabel] = []
    //private var beatLabelsB: [UILabel] = []
    
    var seq = Sequencer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .AVAudioEngineConfigurationChange, object: nil)
        
        seq.tempo = Tempo(bpm: 120, sampleRate: K.Sequencer.sampleRate)
        
        seq.tracks[0].numberOfCellsActive = 16 // kick
        seq.tracks[0].cells = [
            .ON, .OFF, .OFF, .ON,
            .OFF, .OFF, .ON, .OFF,
            .OFF, .OFF, .OFF, .OFF,
            .OFF, .ON, .OFF, .OFF
        ]
        
        seq.tracks[1].numberOfCellsActive = 16 // snare
        seq.tracks[1].cells = [.OFF, .OFF, .OFF, .OFF,
                               .ON, .OFF, .OFF, .OFF,
                               .OFF, .OFF, .OFF, .ON,
                               .OFF, .OFF, .OFF, .OFF
        ]
        
        seq.tracks[2].numberOfCellsActive = 6 // click1
        seq.tracks[2].cells = [.OFF, .OFF, .OFF, .OFF,
                               .ON, .OFF, .OFF, .OFF,
                               .OFF, .OFF, .OFF, .OFF,
                               .ON, .OFF, .OFF, .OFF
                               
        ]
        
        seq.tracks[3].numberOfCellsActive = 16 // click2
        seq.tracks[3].cells = [.OFF, .OFF, .ON, .OFF,
                               .OFF, .OFF, .ON, .OFF,
                               .OFF, .OFF, .ON, .OFF,
                               .OFF, .OFF, .ON, .OFF
                               
        ]

        print(seq.getPeriodLengthInSamples(forTrack: 0))
        print(seq.getPeriodLengthInSamples(forTrack: 1))
        print(seq.getPeriodLengthInSamples(forTrack: 2))
        print(seq.getPeriodLengthInSamples(forTrack: 3))
        
        // Connect data:
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(90, inComponent: 0, animated: true) // start at 120 bpm
        picker.selectRow(0, inComponent: 1, animated: true) // decimal point
        picker.selectRow(0, inComponent: 2, animated: true) // start at 0 as decimal
        
        
        //beatLabels = [beat1Label, beat2Label, beat3Label, beat4Label, beat5Label, beat6Label, beat7Label, beat8Label]
        //beatLabelsB = [beat1LabelB, beat2LabelB, beat3LabelB, beat4LabelB, beat5LabelB, beat6LabelB, beat7LabelB, beat8LabelB]
        
//        for label in beatLabels {
//            label.backgroundColor = .none
//            label.layer.borderColor = UIColor.orange.cgColor
//            label.layer.borderWidth = 3.0
//        }
//        for label in beatLabelsB {
//            label.backgroundColor = .none
//            label.layer.borderColor = UIColor.orange.cgColor
//            label.layer.borderWidth = 3.0
//        }
        
        track0Buttons = [button0_0, button0_1, button0_2, button0_3,
                         button0_4, button0_5, button0_6, button0_7,
                         button0_8, button0_9, button0_10, button0_11,
                         button0_12, button0_13, button0_14, button0_15]
        
        track1Buttons = [button1_0, button1_1, button1_2, button1_3,
                         button1_4, button1_5, button1_6, button1_7,
                         button1_8, button1_9, button1_10, button1_11,
                         button1_12, button1_13, button1_14, button1_15]
        
        track2Buttons = [button2_0, button2_1, button2_2, button2_3,
                         button2_4, button2_5, button2_6, button2_7,
                         button2_8, button2_9, button2_10, button2_11,
                         button2_12, button2_13, button2_14, button2_15]
        
        track3Buttons = [button3_0, button3_1, button3_2, button3_3,
                         button3_4, button3_5, button3_6, button3_7,
                         button3_8, button3_9, button3_10, button3_11,
                         button3_12, button3_13, button3_14, button3_15]
        
        trackButtonMatrix = [track0Buttons, track1Buttons, track2Buttons, track3Buttons]
        
        muteButtons = [mute0Button, mute1Button, mute2Button, mute3Button]
        
        controlButtons = [playPauseButton, tapButton, bpmLabel, stepper, picker]
        
        players = [player0, player1, player2, player3]
        
        //
        // player0: Style & hide all buttons
        //
        for (index, button) in track0Buttons.enumerated() {
            print("Index: \(index)")
            //button.backgroundColor = .none
            button.layer.borderColor = K.Sequencer.trackColors[0].cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = true
            button.titleLabel?.text = ""
            button.tag = index
//            button.setBackgroundColor(color: .clear, forState: .normal)
//            button.setBackgroundColor(color: .orange, forState: .selected)
        }
        //
        // Show only active buttons
        //
        for i in 0...(seq.tracks[0].numberOfCellsActive-1) {
            track0Buttons[i].isHidden = false
        }
        //
        // player1: Style & hide all buttons
        //
        for (index, button) in track1Buttons.enumerated() {
            print("Index: \(index)")
            //button.backgroundColor = .none
            button.layer.borderColor = K.Sequencer.trackColors[1].cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = true
            button.titleLabel?.text = ""
            button.tag = index
            button.setBackgroundColor(color: .clear, forState: .normal)
            button.setBackgroundColor(color: .orange, forState: .selected)
        }
        //
        // Show only active buttons
        //
        for i in 0...(seq.tracks[1].numberOfCellsActive-1) {
            track1Buttons[i].isHidden = false
        }
        
        //
        // player2: Style & hide all buttons
        //
        for (index, button) in track2Buttons.enumerated() {
            print("Index: \(index)")
            //button.backgroundColor = .none
            button.layer.borderColor = K.Sequencer.trackColors[2].cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = true
            button.titleLabel?.text = ""
            button.tag = index
            button.setBackgroundColor(color: .clear, forState: .normal)
            button.setBackgroundColor(color: .orange, forState: .selected)
        }
        //
        // Show only active buttons
        //
        for i in 0...(seq.tracks[2].numberOfCellsActive-1) {
            track2Buttons[i].isHidden = false
        }
        
        //
        // player3: Style & hide all buttons
        //
        for (index, button) in track3Buttons.enumerated() {
            print("Index: \(index)")
            //button.backgroundColor = .none
            button.layer.borderColor = K.Sequencer.trackColors[3].cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = true
            button.titleLabel?.text = ""
            button.tag = index
            button.setBackgroundColor(color: .clear, forState: .normal)
            button.setBackgroundColor(color: .orange, forState: .selected)
        }
        //
        // Show only active buttons
        //
        for i in 0...(seq.tracks[3].numberOfCellsActive-1) {
            track3Buttons[i].isHidden = false
        }
        
        //
        // muteButtons
        //
        for (index, button) in muteButtons.enumerated() {
            print("Index: \(index)")
            button.backgroundColor = K.Sequencer.muteButtonColor
            button.layer.borderColor = K.Sequencer.muteButtonColor.cgColor
            button.layer.borderWidth = 2
            button.isHidden = false
            button.titleLabel?.text = ""
            button.layer.cornerRadius = 15
            button.tag = index
//            button.setBackgroundColor(color: .clear, forState: .normal)
//            button.setBackgroundColor(color: .orange, forState: .selected)
        }
        
        
        for uielement in controlButtons{
            uielement.backgroundColor = .lightGray
            if let label = uielement as? UILabel {
                label.textColor = .white
                label.backgroundColor = K.Sequencer.controlButtonsColor
            }
            if let button = uielement as? UIButton {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = K.Sequencer.controlButtonsColor
            }
            if let stepper = uielement as? UIStepper {
                stepper.tintColor = .white
                stepper.backgroundColor = K.Sequencer.controlButtonsColor
            }
            if let picker = uielement as? UIPickerView {
                picker.tintColor = .white
                picker.backgroundColor = K.Sequencer.controlButtonsColor
            }
           
        }
        
        
        updateUI()
        
        stepper.minimumValue = 30
        stepper.maximumValue = 300
        stepper.stepValue = 1
        stepper.value = seq.tempo!.bpm
        bpmLabel.text = String(seq.tempo!.bpm)
        
        loadBuffers()
        
        
        //        buffers = [buffer0, buffer0Silence,
        //                   buffer1, buffer1Silence,
        //                   buffer2, buffer2Silence,
        //                   buffer3, buffer3Silence
        //    ]
        //        for buffer in buffers {
        //            print(buffer.frameLength)
        //        }
        
        //
        // MARK: Configure + start engine
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
        
        engine.attach(player0)
        engine.attach(player1)
        engine.attach(player2)
        engine.attach(player3)
        
        engine.connect(player0, to: engine.mainMixerNode, format: file0.processingFormat)
        engine.connect(player1, to: engine.mainMixerNode, format: file1.processingFormat)
        engine.connect(player2, to: engine.mainMixerNode, format: file2.processingFormat)
        engine.connect(player3, to: engine.mainMixerNode, format: file3.processingFormat)
        
        engine.prepare()
        do { try engine.start() } catch { print(error) }
        
        
        preScheduleFirstBuffer()
        
        
    }
    
    func loadBuffers() {
        
        //
        // MARK: Loading buffer0 - attached to player0 - TODO: file0 / file1 / ... will be made variable later!
        //
        let path0 = Bundle.main.path(forResource: fileName2, ofType: nil)!
        let url0 = URL(fileURLWithPath: path0)
        do {file0 = try AVAudioFile(forReading: url0)
            buffer0 = AVAudioPCMBuffer(
                pcmFormat: file0.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 0)))
            try file0.read(into: buffer0!)
            buffer0.frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 0))
        } catch { print("Error loading buffer0 \(error)") }
        
        //
        // MARK: Loading buffer1 - etc...
        //
        let path1 = Bundle.main.path(forResource: fileName3, ofType: nil)!
        let url1 = URL(fileURLWithPath: path1)
        do {file1 = try AVAudioFile(forReading: url1)
            buffer1 = AVAudioPCMBuffer(
                pcmFormat: file1.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 1)))
            try file1.read(into: buffer1!)
            buffer1.frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 1))
        } catch { print("Error loading buffer1 \(error)") }
        
        //
        // MARK: Loading buffer2
        //
        let path2 = Bundle.main.path(forResource: fileName4, ofType: nil)!
        let url2 = URL(fileURLWithPath: path2)
        do {file2 = try AVAudioFile(forReading: url2)
            buffer2 = AVAudioPCMBuffer(
                pcmFormat: file2.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 2)))
            try file2.read(into: buffer2!)
            buffer2.frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 2))
        } catch { print("Error loading buffer2 \(error)") }
        
        //
        // MARK: Loading buffer3
        //
        let path3 = Bundle.main.path(forResource: fileName5, ofType: nil)!
        let url3 = URL(fileURLWithPath: path3)
        do {file3 = try AVAudioFile(forReading: url3)
            buffer3 = AVAudioPCMBuffer(
                pcmFormat: file3.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 3)))
            try file3.read(into: buffer3!)
            buffer3.frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 3))
        } catch { print("Error loading buffer3 \(error)") }
        
        //
        // MARK: Loading buffer0Silence
        //
        let pathSilence0 = Bundle.main.path(forResource: fileNameSilence, ofType: nil)!
        let urlSilence0 = URL(fileURLWithPath: pathSilence0)
        do {
            fileSilence = try AVAudioFile(forReading: urlSilence0)
            buffer0Silence = AVAudioPCMBuffer(
                pcmFormat: fileSilence.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 0)))
            try fileSilence.read(into: buffer0Silence!)
            buffer0Silence.frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 0))
        } catch {
            print("Error loading buffer0 \(error)")
        }
        
        //
        // MARK: Loading buffer1Silence
        //
        let pathSilence1 = Bundle.main.path(forResource: fileNameSilence, ofType: nil)!
        let urlSilence1 = URL(fileURLWithPath: pathSilence1)
        do {
            fileSilence = try AVAudioFile(forReading: urlSilence1)
            buffer1Silence = AVAudioPCMBuffer(
                pcmFormat: fileSilence.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 1)))
            try fileSilence.read(into: buffer1Silence!)
            buffer1Silence.frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 1))
        } catch {
            print("Error loading buffer1 \(error)")
        }
        
        //
        // MARK: Loading buffer2Silence
        //
        let pathSilence2 = Bundle.main.path(forResource: fileNameSilence, ofType: nil)!
        let urlSilence2 = URL(fileURLWithPath: pathSilence2)
        do {
            fileSilence = try AVAudioFile(forReading: urlSilence2)
            buffer2Silence = AVAudioPCMBuffer(
                pcmFormat: fileSilence.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 2)))
            try fileSilence.read(into: buffer2Silence!)
            buffer2Silence.frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 2))
        } catch {
            print("Error loading buffer2 \(error)")
        }
        
        //
        // MARK: Loading buffer3Silence
        //
        let pathSilence3 = Bundle.main.path(forResource: fileNameSilence, ofType: nil)!
        let urlSilence3 = URL(fileURLWithPath: pathSilence3)
        do {
            fileSilence = try AVAudioFile(forReading: urlSilence3)
            buffer3Silence = AVAudioPCMBuffer(
                pcmFormat: fileSilence.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 3)))
            try fileSilence.read(into: buffer3Silence!)
            buffer3Silence.frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 3))
        } catch {
            print("Error loading buffer3 \(error)")
        }
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
            //for label in self.beatLabels {label.text = ""}
            
            timer0.invalidate()
            timerEventCounter0 = 1
            currentStep0 = 1
            
            timer1.invalidate()
            timerEventCounter1 = 1
            currentStep1 = 1
            
            timer2.invalidate()
            timerEventCounter2 = 1
            currentStep2 = 1

            timer3.invalidate()
            timerEventCounter3 = 1
            currentStep3 = 1

            preScheduleFirstBuffer()
            
        } else {
            
            //
            // Go!
            //
            state = .run
            playPauseButton.setImage(UIImage(systemName: K.Image.pauseImage), for: .normal)
            
            startPlayers()
            
            startTimer()
        }
    }
    
    fileprivate func startTimer() {
        
        if DEBUG {
            print("# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  ")
            print()
        }
        
        //
        //  Timer for player0
        //
        let timerIntervallInSeconds0 = self.seq.getPeriodLengthInSamples(forTrack: 0) / (2 * K.Sequencer.sampleRate)
        timer0 = Timer.scheduledTimer(withTimeInterval: timerIntervallInSeconds0, repeats: true) { timer in
            
            //
            // Compute & dump debug values
            //
            // Values at begin of timer event
            var currentTime = round(self.player0.currentTimeInSeconds, toDigits: 3)
            if DEBUG {
                print("player 0 timerEvent #\(self.timerEventCounter0) at \(self.seq.tempo!.bpm) BPM")
                print("Entering \ttimerEvent: \(self.timerEventCounter0) \tstep: \(self.currentStep0) \tcurrTime: \(currentTime)")
            }
            //
            // Schedule next buffer or ???
            //
            var bufferScheduled: String = "" // only needed for debugging / console output
            
            if self.timerEventCounter0 % 2 == 1 {
                
                //
                // schedule next buffer
                //
                var nextStep = self.currentStep0
                if nextStep == self.seq.tracks[0].numberOfCellsActive {
                    nextStep = 0
                }
                let nextCell = self.seq.tracks[0].cells[nextStep]
                
                if nextCell == .ON {
                    self.player0.scheduleBuffer(self.buffer0, at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer0"
                } else {
                    self.player0.scheduleBuffer(self.buffer0Silence, at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer0Silence"
                }
            } else {
                //
                // increase stepCounter
                //
                self.currentStep0 += 1
                if self.currentStep0 > self.seq.tracks[0].numberOfCellsActive {
                    self.currentStep0 = 1
                }
            }
            
            //
            // Increase timerEventCounter, two events per beat.
            //
            self.timerEventCounter0 += 1
            
            if self.timerEventCounter0 > (self.seq.tracks[0].numberOfCellsActive * 2) {
                self.timerEventCounter0 = 1
            }
            
            //
            //
            // Display current beat & increase currentBeat (1...4) at 2nd, 4th, 6th & 8th timerEvent
            //
            //            if self.timerEventCounter0 % 2 == 0 {
            //                for label in self.beatLabels {label.text = ""}
            DispatchQueue.main.async {
                //self.track0buttons[self.currentStep0-1].text = String(self.currentStep0)
                self.track0Buttons[self.currentStep0 - 1].flash()
            }
            //                self.currentStep0 += 1; if self.currentStep0 > 4 {self.currentStep0 = 1}
            //            }
            
            // Values at end of timer event
            if DEBUG {
                currentTime = round(self.player0.currentTimeInSeconds, toDigits: 3)
                print("Exiting \ttimerEvent: \(self.timerEventCounter0) \tstep: \(self.currentStep0) \tcurrTime: \(currentTime) \t\(bufferScheduled)")
                print()
            }
        }
        
        //
        //  Timer for player1
        //
        let timerIntervallInSeconds1 = self.seq.getPeriodLengthInSamples(forTrack: 1) / (2 * K.Sequencer.sampleRate)
        timer1 = Timer.scheduledTimer(withTimeInterval: timerIntervallInSeconds1, repeats: true) { timer in
            
            //
            // Compute & dump debug values
            //
            // Values at begin of timer event
            var currentTime = round(self.player1.currentTimeInSeconds, toDigits: 3)
            if DEBUG {
                print("player 1 timerEvent #\(self.timerEventCounter1) at \(self.seq.tempo!.bpm) BPM")
                print("Entering \ttimerEvent: \(self.timerEventCounter1) \tstep: \(self.currentStep1) \tcurrTime: \(currentTime)")
            }
            //
            // Schedule next buffer or ???
            //
            var bufferScheduled: String = "" // only needed for debugging / console output
            
            if self.timerEventCounter1 % 2 == 1 {
                
                //
                // schedule next buffer
                //
                var nextStep = self.currentStep1
                if nextStep == self.seq.tracks[1].numberOfCellsActive {
                    nextStep = 0
                }
                let nextCell = self.seq.tracks[1].cells[nextStep]
                
                if nextCell == .ON {
                    self.player1.scheduleBuffer(self.buffer1, at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer1"
                } else {
                    self.player1.scheduleBuffer(self.buffer1Silence, at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer1Silence"
                }
            } else {
                //
                // increase stepCounter
                //
                self.currentStep1 += 1
                if self.currentStep1 > self.seq.tracks[1].numberOfCellsActive {
                    self.currentStep1 = 1
                }
            }
            
            //
            // Increase timerEventCounter, two events per beat.
            //
            self.timerEventCounter1 += 1
            
            if self.timerEventCounter1 > (self.seq.tracks[1].numberOfCellsActive * 2) {
                self.timerEventCounter1 = 1
            }
            
            //
//                        if self.timerEventCounter0 % 2 == 0 {
            //                for label in self.beatLabels {label.text = ""}
            DispatchQueue.main.async {
                //self.beatLabels[self.currentStep0-1].text = String(self.currentStep0)
                self.track1Buttons[self.currentStep1 - 1].flash()
            }
            //                self.currentStep0 += 1; if self.currentStep0 > 4 {self.currentStep0 = 1}
            //            }
            
            // Values at end of timer event
            if DEBUG {
                currentTime = round(self.player1.currentTimeInSeconds, toDigits: 3)
                print("Exiting \ttimerEvent: \(self.timerEventCounter1) \tstep: \(self.currentStep1) \tcurrTime: \(currentTime) \t\(bufferScheduled)")
                print()
            }
        }
        
        //
        //  Timer for player2
        //
        let timerIntervallInSeconds2 = self.seq.getPeriodLengthInSamples(forTrack: 2) / (2 * K.Sequencer.sampleRate)
        timer2 = Timer.scheduledTimer(withTimeInterval: timerIntervallInSeconds2, repeats: true) { timer in
            
            //
            // Compute & dump debug values
            //
            // Values at begin of timer event
            var currentTime = round(self.player2.currentTimeInSeconds, toDigits: 3)
            if DEBUG {
                print("player 2 timerEvent #\(self.timerEventCounter2) at \(self.seq.tempo!.bpm) BPM")
                print("Entering \ttimerEvent: \(self.timerEventCounter2) \tstep: \(self.currentStep2) \tcurrTime: \(currentTime)")
            }
            //
            // Schedule next buffer or ???
            //
            var bufferScheduled: String = "" // only needed for debugging / console output
            
            if self.timerEventCounter2 % 2 == 1 {
                
                //
                // schedule next buffer
                //
                var nextStep = self.currentStep2
                if nextStep == self.seq.tracks[2].numberOfCellsActive {
                    nextStep = 0
                }
                let nextCell = self.seq.tracks[2].cells[nextStep]
                
                if nextCell == .ON {
                    self.player2.scheduleBuffer(self.buffer2, at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer2"
                } else {
                    self.player2.scheduleBuffer(self.buffer2Silence, at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer2Silence"
                }
            } else {
                //
                // increase stepCounter
                //
                self.currentStep2 += 1
                if self.currentStep2 > self.seq.tracks[2].numberOfCellsActive {
                    self.currentStep2 = 1
                }
            }
            
            //
            // Increase timerEventCounter, two events per beat.
            //
            self.timerEventCounter2 += 1
            
            if self.timerEventCounter2 > (self.seq.tracks[2].numberOfCellsActive * 2) {
                self.timerEventCounter2 = 1
            }
            
            //
            //
            // Display current beat & increase currentBeat (1...4) at 2nd, 4th, 6th & 8th timerEvent
            //
            //            if self.timerEventCounter0 % 2 == 0 {
            //                for label in self.beatLabels {label.text = ""}
            DispatchQueue.main.async {
                //                    self.beatLabels[self.currentStep0-1].text = String(self.currentStep0)
                self.track2Buttons[self.currentStep2 - 1].flash()
            }
            //                self.currentStep0 += 1; if self.currentStep0 > 4 {self.currentStep0 = 1}
            //            }
            
            // Values at end of timer event
            if DEBUG {
                currentTime = round(self.player2.currentTimeInSeconds, toDigits: 3)
                print("Exiting \ttimerEvent: \(self.timerEventCounter2) \tstep: \(self.currentStep2) \tcurrTime: \(currentTime) \t\(bufferScheduled)")
                print()
            }
        }

        //
        //  Timer for player3
        //
        let timerIntervallInSeconds3 = self.seq.getPeriodLengthInSamples(forTrack: 3) / (2 * K.Sequencer.sampleRate)
        timer3 = Timer.scheduledTimer(withTimeInterval: timerIntervallInSeconds3, repeats: true) { timer in
            
            //
            // Compute & dump debug values
            //
            // Values at begin of timer event
            var currentTime = round(self.player3.currentTimeInSeconds, toDigits: 3)
            if DEBUG {
                print("player 3 timerEvent #\(self.timerEventCounter3) at \(self.seq.tempo!.bpm) BPM")
                print("Entering \ttimerEvent: \(self.timerEventCounter3) \tstep: \(self.currentStep3) \tcurrTime: \(currentTime)")
            }
            //
            // Schedule next buffer or ???
            //
            var bufferScheduled: String = "" // only needed for debugging / console output
            
            if self.timerEventCounter3 % 2 == 1 {
                
                //
                // schedule next buffer
                //
                var nextStep = self.currentStep3
                if nextStep == self.seq.tracks[3].numberOfCellsActive {
                    nextStep = 0
                }
                let nextCell = self.seq.tracks[3].cells[nextStep]
                
                if nextCell == .ON {
                    self.player3.scheduleBuffer(self.buffer3, at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer3"
                } else {
                    self.player3.scheduleBuffer(self.buffer3Silence, at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer3Silence"
                }
            } else {
                //
                // increase stepCounter
                //
                self.currentStep3 += 1
                if self.currentStep3 > self.seq.tracks[3].numberOfCellsActive {
                    self.currentStep3 = 1
                }
            }
            
            //
            // Increase timerEventCounter, two events per beat.
            //
            self.timerEventCounter3 += 1
            
            if self.timerEventCounter3 > (self.seq.tracks[3].numberOfCellsActive * 2) {
                self.timerEventCounter3 = 1
            }
            
            //
            //
            // Display current beat & increase currentBeat (1...4) at 2nd, 4th, 6th & 8th timerEvent
            //
            //            if self.timerEventCounter0 % 2 == 0 {
            //                for label in self.beatLabels {label.text = ""}
            DispatchQueue.main.async {
                //                    self.beatLabels[self.currentStep0-1].text = String(self.currentStep0)
                self.track3Buttons[self.currentStep3 - 1].flash()
            }
            //                self.currentStep0 += 1; if self.currentStep0 > 4 {self.currentStep0 = 1}
            //            }
            
            // Values at end of timer event
            if DEBUG {
                currentTime = round(self.player3.currentTimeInSeconds, toDigits: 3)
                print("Exiting \ttimerEvent: \(self.timerEventCounter3) \tstep: \(self.currentStep3) \tcurrTime: \(currentTime) \t\(bufferScheduled)")
                print()
            }
        }

        
    }
    
    //
    // MARK:- startPlayers
    //
    private func startPlayers() {
        
        //        player.stop()
        //
        //        //
        //        // pre-load accented main sound (for beat "1") before trigger starts
        //        //
        //        player.scheduleBuffer(buffer1, at: nil, options: [], completionHandler: nil)
        player0.play()
        //beat1Label.text = String(currentStep0)
        //beatLabels[currentStep0-1].flash(intervalDuration: 0.05, intervals: 2)
        
        player1.play()
        //        beat1Label.text = String(currentBeat)
        //        beatLabels[currentBeat-1].flash(intervalDuration: 0.05, intervals: 2)
        
        player2.play()
        //        beat1Label.text = String(currentBeat)
        //        beatLabels[currentBeat-1].flash(intervalDuration: 0.05, intervals: 2)
        
        player3.play()
        //        beat1Label.text = String(currentBeat)
        //        beatLabels[currentBeat-1].flash(intervalDuration: 0.05, intervals: 2)
        
        //print("currentBeat = \(currentBeat)")
    }
    
    //
    // MARK:- preScheduleFirstBuffer
    //
    private func preScheduleFirstBuffer() {
        
        //
        // player0
        //
        player0.stop()
        if seq.tracks[0].cells[0] == .ON {
            //
            // Schedule sound
            //
            player0.scheduleBuffer(buffer0, at: nil, options: [], completionHandler: nil)
        } else {
            //
            // Schedule silence
            //
            player0.scheduleBuffer(buffer0Silence, at: nil, options: [], completionHandler: nil)
        }
        player0.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 0)))

        //
        // player1
        //
        player1.stop()
        if seq.tracks[1].cells[0] == .ON {
            //
            // Schedule sound
            //
            player1.scheduleBuffer(buffer1, at: nil, options: [], completionHandler: nil)
        } else {
            //
            // Schedule silence
            //
            player1.scheduleBuffer(buffer1Silence, at: nil, options: [], completionHandler: nil)
        }
        player1.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 1)))

        //
        // player2
        //
        player2.stop()
        if seq.tracks[2].cells[0] == .ON {
            //
            // Schedule sound
            //
            player2.scheduleBuffer(buffer2, at: nil, options: [], completionHandler: nil)
        } else {
            //
            // Schedule silence
            //
            player2.scheduleBuffer(buffer2Silence, at: nil, options: [], completionHandler: nil)
        }
        player2.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 1)))
        
        //
        // player3
        //
        player3.stop()
        if seq.tracks[3].cells[0] == .ON {
            //
            // Schedule sound
            //
            player3.scheduleBuffer(buffer3, at: nil, options: [], completionHandler: nil)
        } else {
            //
            // Schedule silence
            //
            player3.scheduleBuffer(buffer3Silence, at: nil, options: [], completionHandler: nil)
        }
        player3.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 3)))
        
        
        //        player1.stop()
        //        player1.scheduleBuffer(buffer3, at: nil, options: [], completionHandler: nil)
        //        player1.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 1)))
        
        //        player3.stop()
        //        player3.scheduleBuffer(buffer3, at: nil, options: [], completionHandler: nil)
        //        player3.prepare(withFrameCount: AVAudioFrameCount(tempo!.periodLengthInSamples))
        //
        //        player4.stop()
        //        player4.scheduleBuffer(buffer4, at: nil, options: [], completionHandler: nil)
        //        player4.prepare(withFrameCount: AVAudioFrameCount(tempo!.periodLengthInSamples))
        //
    }
    
    //
    // MARK:- player0 button pressed action
    //
    @IBAction func button0pressed(_ sender: UIButton) {
        print("Tag: \(sender.tag)")
        
        if track0Buttons[sender.tag].backgroundColor == .none {
            
            //
            // Set Step
            //
            track0Buttons[sender.tag].backgroundColor = K.Sequencer.trackColors[0]
            seq.tracks[0].cells[sender.tag] = .ON
            
        } else {

            //
            // Delete Step
            //
            track0Buttons[sender.tag].backgroundColor = .none
            seq.tracks[0].cells[sender.tag] = .OFF
        }
    }

    //
    // MARK:- player1 button pressed action
    //
    @IBAction func button1pressed(_ sender: UIButton) {
        print("Tag: \(sender.tag)")
        
        if track1Buttons[sender.tag].backgroundColor == .none {
            
            //
            // Set Step
            //
            track1Buttons[sender.tag].backgroundColor = K.Sequencer.trackColors[1]
            seq.tracks[1].cells[sender.tag] = .ON
            
        } else {

            //
            // Delete Step
            //
            track1Buttons[sender.tag].backgroundColor = .none
            seq.tracks[1].cells[sender.tag] = .OFF
        }
    }

    //
    // MARK:- player2 button pressed action
    //
    @IBAction func button2pressed(_ sender: UIButton) {
        print("Tag: \(sender.tag)")
        
        if track2Buttons[sender.tag].backgroundColor == .none {
            
            //
            // Set Step
            //
            track2Buttons[sender.tag].backgroundColor = K.Sequencer.trackColors[2]
            seq.tracks[2].cells[sender.tag] = .ON
            
        } else {

            //
            // Delete Step
            //
            track2Buttons[sender.tag].backgroundColor = .none
            seq.tracks[2].cells[sender.tag] = .OFF
        }
    }
    
    //
    // MARK:- player3 button pressed action
    //
    @IBAction func button3pressed(_ sender: UIButton) {
        print("Tag: \(sender.tag)")
        
        if track3Buttons[sender.tag].backgroundColor == .none {
            
            //
            // Set Step
            //
            track3Buttons[sender.tag].backgroundColor = K.Sequencer.trackColors[3]
            seq.tracks[3].cells[sender.tag] = .ON
            
        } else {

            //
            // Delete Step
            //
            track3Buttons[sender.tag].backgroundColor = .none
            seq.tracks[3].cells[sender.tag] = .OFF
        }
    }
    
    //
    // MARK:- muteButton action
    //
    @IBAction func muteButtonPressed(_ sender: UIButton) {
        
        seq.tracks[sender.tag].muted = !seq.tracks[sender.tag].muted

        if seq.tracks[sender.tag].muted {
            //
            // Mute row / player
            //
            players[sender.tag].volume = 0
            muteButtons[sender.tag].backgroundColor = .none
            
            let buttonRowToBeMuted = trackButtonMatrix[sender.tag]
            for button in buttonRowToBeMuted {
                button.alpha = 0.3
            }
            
        } else {
            //
            // Un-mute row / player
            //
            players[sender.tag].volume = 1
            muteButtons[sender.tag].backgroundColor = K.Sequencer.muteButtonColor
            
            let buttonRowToBeUnmuted = trackButtonMatrix[sender.tag]
            for button in buttonRowToBeUnmuted {
                button.alpha = 1
            }

        }
        
        print(sender.tag)

        
    }
    
    //
    // MARK:- updateUI
    //
    func updateUI() {
        //
        // color player buttons according to state of seq.tracks[...].cells[...]
        // state .ON = backgroundColor = .orange, state .OFF = backgroundColor .none
        
        for (index, button) in track0Buttons.enumerated() {
            
            if seq.tracks[0].cells[index] == .ON {
                
                button.backgroundColor = K.Sequencer.trackColors[0]
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track1Buttons.enumerated() {
            
            if seq.tracks[1].cells[index] == .ON {
                
                button.backgroundColor = K.Sequencer.trackColors[1]
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track2Buttons.enumerated() {
            
            if seq.tracks[2].cells[index] == .ON {
                
                button.backgroundColor = K.Sequencer.trackColors[2]
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track3Buttons.enumerated() {
            
            if seq.tracks[3].cells[index] == .ON {
                
                button.backgroundColor = K.Sequencer.trackColors[3]
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        
    }
}

//
// MARK:- UIPicker Data Source & Delegate
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
    
    @objc func onDidReceiveData(_ notification: Notification) {
        print(#function)
        print(notification)
        print()
    }
    
    
    private func tempoChanged(to newTempo: Double) {
        
        //
        // Set new tempo, display value, load new buffers
        //
        seq.tempo?.bpm = newTempo
        bpmLabel.text = String(seq.tempo!.bpm)
  
        loadBuffers()

        //        for label in self.beatLabels {label.text = ""}
        
        //
        // Stop timer
        //
        if timer0 != nil {
            timer0.invalidate()
        }
        timerEventCounter0 = 1
        currentStep0 = 1
        
        if timer1 != nil {
            timer1.invalidate()
        }
        timerEventCounter1 = 1
        currentStep1 = 1
        
        if timer2 != nil {
            timer2.invalidate()
        }
        timerEventCounter2 = 1
        currentStep2 = 1
 
        if timer3 != nil {
            timer3.invalidate()
        }
        timerEventCounter3 = 1
        currentStep3 = 1
 
        //
        //  Start again
        //
        if state == .run {
            startPlayers()
            startTimer()
        }
    }
}
