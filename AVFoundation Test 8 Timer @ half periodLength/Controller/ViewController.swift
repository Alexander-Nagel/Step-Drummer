// uing timer to schedule buffers
// https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer


import UIKit
import AVFoundation

fileprivate let DEBUG = false

class ViewController: UIViewController{
    
    private var engine = AVAudioEngine()
    
//    private var player0 = AVAudioPlayerNode()
//    private var player1 = AVAudioPlayerNode()
//    private var player2 = AVAudioPlayerNode()
//    private var player3 = AVAudioPlayerNode()
//
    private var players = [AVAudioPlayerNode(), AVAudioPlayerNode(),
                           AVAudioPlayerNode(), AVAudioPlayerNode()]
    
    private var reverb2 = AVAudioUnitReverb()
    
    private var reverbs = [AVAudioUnitReverb(), AVAudioUnitReverb(),
                           AVAudioUnitReverb(), AVAudioUnitReverb()]
    
    private var mixer = AVAudioMixerNode()
    
    private var bpmDetector = BpmDetector()
    
    //private let fileName0 = "sound1.wav"
    //private let fileName1 = "sound2.wav"
//    private let fileName0 = "kick_2156samples.wav"
//    private let fileName1 = "snare_2152samples.wav"
//    private let fileName2 = "hihat_2154samples.wav"
//    private let fileName3 = "open_hihat_2181samples.wav"
    private let fileNameSilence = "silence.wav"
    private let fileNames = ["kick_2156samples.wav",
                             "snare_2152samples.wav",
                             "hihat_2154samples.wav",
                             "open_hihat_2181samples.wav"]
    
    //    private let fileNameLong = "pcm stereo 16 bit 44.1kHz.wav"
//    private var file0: AVAudioFile! = nil
//    private var file1: AVAudioFile! = nil
//    private var file2: AVAudioFile! = nil
//    private var file3: AVAudioFile! = nil
    private var files =  [AVAudioFile]()
    
    private var fileSilence: AVAudioFile! = nil
    
//    private var buffer0: AVAudioPCMBuffer! = nil
//    private var buffer1: AVAudioPCMBuffer! = nil
//    private var buffer2: AVAudioPCMBuffer! = nil
//    private var buffer3: AVAudioPCMBuffer! = nil
    
    private var soundBuffers = [AVAudioPCMBuffer]()
    
//    private var buffer0Silence: AVAudioPCMBuffer! = nil
//    private var buffer1Silence: AVAudioPCMBuffer! = nil
//    private var buffer2Silence: AVAudioPCMBuffer! = nil
//    private var buffer3Silence: AVAudioPCMBuffer! = nil
    
    private var silenceBuffers = [AVAudioPCMBuffer]()

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
    private let pickerDataArray = [Array(30...300).map{String($0)}, ["."], Array(0...9).map{String($0)}]
    private var pickedLeft: Int = 120
    private var pickedRight: Int = 0
    
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
    
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var bpmLabel: UILabel!
    
    @IBOutlet weak var bpmStepper: UIStepper!
    @IBOutlet weak var bpmStepperView: UIView!
   
    
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    @IBOutlet weak var mute0Button: UIButton!
    @IBOutlet weak var mute1Button: UIButton!
    @IBOutlet weak var mute2Button: UIButton!
    @IBOutlet weak var mute3Button: UIButton!
    
    private var muteButtons: [UIButton] = []
    
    
    @IBOutlet weak var stepper0Button: UIStepper!
    @IBOutlet weak var stepper1Button: UIStepper!
    @IBOutlet weak var stepper2Button: UIStepper!
    @IBOutlet weak var stepper3Button: UIStepper!
    
    private var stepperButtons: [UIStepper] = []
    
    @IBOutlet weak var stepper0View: UIView!
    @IBOutlet weak var stepper1View: UIView!
    @IBOutlet weak var stepper2View: UIView!
    @IBOutlet weak var stepper3View: UIView!
    
    private var stepperViews: [UIView] = []
    
    
    private var controlButtons: [UIView] = []
    
    //private var beatLabels: [UILabel] = []
    //private var beatLabelsB: [UILabel] = []
    
    var seq = Sequencer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        files = [AVAudioFile(), AVAudioFile(), AVAudioFile(), AVAudioFile()]
        soundBuffers = [AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer()]
        silenceBuffers = [AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer()]
        
       // NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .AVAudioEngineConfigurationChange, object: nil)
        
        seq.tempo = Tempo(bpm: 120, sampleRate: K.Sequencer.sampleRate)
        
        seq.tracks[0].numberOfCellsActive = DefaultPatterns.kick1.length
        seq.tracks[0].cells = DefaultPatterns.kick1.data
        
        seq.tracks[1].numberOfCellsActive = DefaultPatterns.snare1.length
        seq.tracks[1].cells = DefaultPatterns.snare1.data
        
        seq.tracks[2].numberOfCellsActive = DefaultPatterns.closedHihat1.length
        seq.tracks[2].cells = DefaultPatterns.closedHihat1.data
        
        seq.tracks[3].numberOfCellsActive = DefaultPatterns.openHihat1.length
        seq.tracks[3].cells = DefaultPatterns.openHihat1.data

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
        
        stepperButtons = [stepper0Button, stepper1Button, stepper2Button, stepper3Button]
        
        stepperViews = [stepper0View, stepper1View, stepper2View, stepper3View ]
        
        controlButtons = [playPauseButton, tapButton, bpmLabel, bpmStepper, picker]
        
        //players = [player0, player1, player2, player3]
        
        //
        // player0: Style & hide all buttons
        //
        for (index, button) in track0Buttons.enumerated() {
            print("Index: \(index)")
            //button.backgroundColor = .none
            button.layer.borderColor = K.Sequencer.playerButtonBorderColors[0].cgColor
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
            button.layer.borderColor = K.Sequencer.playerButtonBorderColors[1].cgColor
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
            button.layer.borderColor = K.Sequencer.playerButtonBorderColors[2].cgColor
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
            button.layer.borderColor = K.Sequencer.playerButtonBorderColors[3].cgColor
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
            button.layer.borderColor = K.Sequencer.muteButtonBorderColor.cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = false
            button.titleLabel?.text = ""
            button.layer.cornerRadius = 15
            button.tag = index
        }
        
        for view in stepperViews {
            view.backgroundColor = K.Sequencer.muteButtonColor
        }
        for (index, stepper) in stepperButtons.enumerated() {
            stepper.backgroundColor = K.Sequencer.muteButtonColor
            
            stepper.minimumValue = 1
            stepper.maximumValue = 16
            stepper.stepValue = 1
            stepper.tag = index
            stepper.value = Double(seq.tracks[index].numberOfCellsActive)
        }
        
        //settingsButton.backgroundColor = .red
        
        
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
                //stepper.tintColor = .white
                stepper.backgroundColor = K.Sequencer.controlButtonsColor
            }
            if let picker = uielement as? UIPickerView {
                picker.tintColor = .white
                picker.backgroundColor = K.Sequencer.controlButtonsColor
            }
            tapButton.setTitleColor(.black, for: .normal)
           
        }
        //stepperOuterStackView.backgroundColor = .white
        //stepperInnerStackView.backgroundColor = .green
        //stepperView.backgroundColor = K.Sequencer.controlButtonsColor
        
        
        updateUI()
        
        bpmStepper.minimumValue = 30
        bpmStepper.maximumValue = 300
        bpmStepper.stepValue = 1
        bpmStepper.value = seq.tempo!.bpm
        bpmLabel.text = String(seq.tempo!.bpm)
        bpmStepperView.backgroundColor = K.Sequencer.controlButtonsColor
        
        //loadBuffersTO_BE_REFACTORED()
        
        loadBuffer(ofPlayer: 0, withFile: 0)
        loadBuffer(ofPlayer: 1, withFile: 1)
        loadBuffer(ofPlayer: 2, withFile: 2)
        loadBuffer(ofPlayer: 3, withFile: 3)
        
        
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
        
        
        
        engine.attach(players[0])
        engine.attach(players[1])
        engine.attach(players[2])
        engine.attach(players[3])
        
//        let format = reverb2.inputFormat(forBus: 0)
//        engine.connect(players[1], to: reverb2, format: format)
//        engine.connect(reverb2, to: engine.outputNode, format: format)
//        
        engine.connect(players[0], to: engine.mainMixerNode, format: files[0].processingFormat)
        engine.connect(players[1], to: engine.mainMixerNode, format: files[1].processingFormat)
        engine.connect(players[2], to: engine.mainMixerNode, format: files[2].processingFormat)
        engine.connect(players[3], to: engine.mainMixerNode, format: files[3].processingFormat)
        
        engine.prepare()
        do { try engine.start() } catch { print(error) }
        
        
        //preScheduleFirstBuffer_OLD()
        preScheduleFirstBuffer(forPlayer: 0)
        preScheduleFirstBuffer(forPlayer: 1)
        preScheduleFirstBuffer(forPlayer: 2)
        preScheduleFirstBuffer(forPlayer: 3)
        
    }
    
    //
    // MARK:- Load buffers (with parameter)
    //
    func loadBuffer(ofPlayer player_to_be_loaded: Int, withFile file_to_load: Int) {
        
        //
        // MARK: Loading buffer - attached to player0 - TODO: file0 / file1 / ... will be made variable later!
        //
        let path = Bundle.main.path(forResource: fileNames[file_to_load], ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {files[file_to_load] = try AVAudioFile(forReading: url)
            soundBuffers[player_to_be_loaded] = AVAudioPCMBuffer(
                pcmFormat: files[file_to_load].processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: player_to_be_loaded)))!
            try files[file_to_load].read(into: soundBuffers[player_to_be_loaded])
            soundBuffers[player_to_be_loaded].frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: player_to_be_loaded))
        } catch { print("Error loading buffer \(player_to_be_loaded) \(error)") }

        
        //
        // MARK: Loading silence buffer
        //
        let pathSilence = Bundle.main.path(forResource: fileNameSilence, ofType: nil)!
        let urlSilence = URL(fileURLWithPath: pathSilence)
        do {
            fileSilence = try AVAudioFile(forReading: urlSilence)
            silenceBuffers[player_to_be_loaded] = AVAudioPCMBuffer(
                pcmFormat: fileSilence.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: player_to_be_loaded)))!
            try fileSilence.read(into: silenceBuffers[player_to_be_loaded])
            silenceBuffers[player_to_be_loaded].frameLength = AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: player_to_be_loaded))
        } catch {
            print("Error loading buffer0 \(player_to_be_loaded) \(error)")
        }

        
    }
    
    
    
    //
    // MARK:- Tap button pressed
    //
    @IBAction func tapButtonPressed(_ sender: UIButton) {
        
        tapButton.flash(intervalDuration: 0.05, intervals: 1)
        
        let newTempo = bpmDetector.tapReceived()
        if DEBUG {print("newTempo: \(newTempo)")}
        
        if newTempo >= 30.0 && newTempo <= 300.0 {
            
            //state = .stop
            //playPauseButton.setImage(UIImage(systemName: K.Image.playImage), for: .normal)
        
            seq.tempo?.bpm = newTempo

            preScheduleFirstBuffer(forPlayer: 0)
            preScheduleFirstBuffer(forPlayer: 1)
            preScheduleFirstBuffer(forPlayer: 2)
            preScheduleFirstBuffer(forPlayer: 3)

            updateUIAfterTempoChange(to: newTempo, restart: true)
            print(newTempo)
            
        }
    }
    
    
    //
    // MARK:- Stepper action
    //
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        let newTempo = bpmStepper.value
        seq.tempo?.bpm = newTempo
        updateUIAfterTempoChange(to: newTempo)
    }
    
    //
    // MARK:- Play / Pause toggle action
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

//            preScheduleFirstBuffer_OLD()
            preScheduleFirstBuffer(forPlayer: 0)
            preScheduleFirstBuffer(forPlayer: 1)
            preScheduleFirstBuffer(forPlayer: 2)
            preScheduleFirstBuffer(forPlayer: 3)
            
            
        } else {
            
            //
            // Go!
            //
            state = .run
            playPauseButton.setImage(UIImage(systemName: K.Image.pauseImage), for: .normal)
            
            startPlayers()
            
            startAllTimers()
        }
    }
    
    fileprivate func startAllTimers() {
        
        if DEBUG {
            print("# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  ")
            print(soundBuffers[0].frameLength, soundBuffers[1].frameLength, soundBuffers[2].frameLength, soundBuffers[3].frameLength)
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
            var currentTime = round(self.players[0].currentTimeInSeconds, toDigits: 3)
            
            print(#function)
            
            print(self.soundBuffers[0].frameLength, self.silenceBuffers[0].frameLength, "  ",
                  self.soundBuffers[1].frameLength, self.silenceBuffers[1].frameLength, "  ",
                  self.soundBuffers[2].frameLength, self.silenceBuffers[2].frameLength, "  ",
                  self.soundBuffers[3].frameLength, self.silenceBuffers[3].frameLength
                  )
            
            if DEBUG {
                print("player 0 timerEvent #\(self.timerEventCounter0) at \(self.seq.tempo!.bpm) BPM")
                print("Entering \ttimerEvent: \(self.timerEventCounter0) \tstep: \(self.currentStep0) \tcurrTime: \(currentTime)")
            }
            //
            // Schedule next buffer on odd events / increase beat conter on even events
            //
            var bufferScheduled: String = "" // only needed for debugging / console output
            
            if self.timerEventCounter0 % 2 == 1 {
                
                //
                // ODD event: schedule next buffer
                //
                var nextStep = self.currentStep0
                if nextStep == self.seq.tracks[0].numberOfCellsActive {
                    nextStep = 0
                }
                let nextCell = self.seq.tracks[0].cells[nextStep]
                
                if nextCell == .ON {
                    self.players[0].scheduleBuffer(self.soundBuffers[0], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer0"
                } else {
                    self.players[0].scheduleBuffer(self.silenceBuffers[0], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer0Silence"
                }
            } else {
                //
                // EVEN event: increase stepCounter
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
                currentTime = round(self.players[0].currentTimeInSeconds, toDigits: 3)
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
            var currentTime = round(self.players[1].currentTimeInSeconds, toDigits: 3)
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
                    self.players[1].scheduleBuffer(self.soundBuffers[1], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer1"
                } else {
                    self.players[1].scheduleBuffer(self.silenceBuffers[1], at: nil, options: [], completionHandler: nil)
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
                currentTime = round(self.players[1].currentTimeInSeconds, toDigits: 3)
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
            var currentTime = round(self.players[2].currentTimeInSeconds, toDigits: 3)
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
                    self.players[2].scheduleBuffer(self.soundBuffers[2], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer2"
                } else {
                    self.players[2].scheduleBuffer(self.silenceBuffers[2], at: nil, options: [], completionHandler: nil)
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
                currentTime = round(self.players[2].currentTimeInSeconds, toDigits: 3)
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
            var currentTime = round(self.players[3].currentTimeInSeconds, toDigits: 3)
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
                    self.players[3].scheduleBuffer(self.soundBuffers[3], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer3"
                } else {
                    self.players[3].scheduleBuffer(self.silenceBuffers[3], at: nil, options: [], completionHandler: nil)
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
                currentTime = round(self.players[3].currentTimeInSeconds, toDigits: 3)
                print("Exiting \ttimerEvent: \(self.timerEventCounter3) \tstep: \(self.currentStep3) \tcurrTime: \(currentTime) \t\(bufferScheduled)")
                print()
            }
        }

        
    }
    
    //
    // MARK:- startPlayers
    //
    private func startPlayers() {
        
        for player in players {
            player.play()
        }
    }
    
    //
    // MARK:- Load all buffers
    //
    private func loadAllBuffers() {
        
        for i in 0...(players.count - 1) {
            loadBuffer(ofPlayer: i, withFile: i)
        }
    }
    
    //
    // MARK:- preScheduleFirstBuffer
    //
//    private func preScheduleFirstBuffer_OLD() {
//
//        print(#function)
//
//        printFrameLengths()
//
//        //
//        // player0
//        //
//        player0.stop()
//        if seq.tracks[0].cells[0] == .ON {
//            //
//            // Schedule sound
//            //
//            player0.scheduleBuffer(soundBuffers[0], at: nil, options: [], completionHandler: nil)
//        } else {
//            //
//            // Schedule silence
//            //
//            player0.scheduleBuffer(silenceBuffers[0], at: nil, options: [], completionHandler: nil)
//        }
//        player0.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 0)))
//
//        //
//        // player1
//        //
//        player1.stop()
//        if seq.tracks[1].cells[0] == .ON {
//            //
//            // Schedule sound
//            //
//            player1.scheduleBuffer(soundBuffers[1], at: nil, options: [], completionHandler: nil)
//        } else {
//            //
//            // Schedule silence
//            //
//            player1.scheduleBuffer(silenceBuffers[1], at: nil, options: [], completionHandler: nil)
//        }
//        player1.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 1)))
//
//        //
//        // player2
//        //
//        player2.stop()
//        if seq.tracks[2].cells[0] == .ON {
//            //
//            // Schedule sound
//            //
//            player2.scheduleBuffer(soundBuffers[2], at: nil, options: [], completionHandler: nil)
//        } else {
//            //
//            // Schedule silence
//            //
//            player2.scheduleBuffer(silenceBuffers[2], at: nil, options: [], completionHandler: nil)
//        }
//        player2.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 2)))
//
//        //
//        // player3
//        //
//        player3.stop()
//        if seq.tracks[3].cells[0] == .ON {
//            //
//            // Schedule sound
//            //
//            player3.scheduleBuffer(soundBuffers[3], at: nil, options: [], completionHandler: nil)
//        } else {
//            //
//            // Schedule silence
//            //
//            player3.scheduleBuffer(silenceBuffers[3], at: nil, options: [], completionHandler: nil)
//        }
//        player3.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 3)))
//
//
//        //        player1.stop()
//        //        player1.scheduleBuffer(buffer3, at: nil, options: [], completionHandler: nil)
//        //        player1.prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: 1)))
//
//        //        player3.stop()
//        //        player3.scheduleBuffer(buffer3, at: nil, options: [], completionHandler: nil)
//        //        player3.prepare(withFrameCount: AVAudioFrameCount(tempo!.periodLengthInSamples))
//        //
//        //        player4.stop()
//        //        player4.scheduleBuffer(buffer4, at: nil, options: [], completionHandler: nil)
//        //        player4.prepare(withFrameCount: AVAudioFrameCount(tempo!.periodLengthInSamples))
//        //
//    }
//
    private func preScheduleFirstBuffer(forPlayer seletedPlayer: Int) {
        
        print(#function)
        
        printFrameLengths()
        
        players[seletedPlayer].stop()
        if seq.tracks[seletedPlayer].cells[0] == .ON {
            //
            // Schedule sound
            //
            players[seletedPlayer].scheduleBuffer(soundBuffers[seletedPlayer], at: nil, options: [], completionHandler: nil)
        } else {
            //
            // Schedule silence
            //
            players[seletedPlayer].scheduleBuffer(silenceBuffers[seletedPlayer], at: nil, options: [], completionHandler: nil)
        }
        players[seletedPlayer].prepare(withFrameCount: AVAudioFrameCount(seq.getPeriodLengthInSamples(forTrack: seletedPlayer)))
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
            track0Buttons[sender.tag].backgroundColor = K.Sequencer.playerButtonColors[0]
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
            track1Buttons[sender.tag].backgroundColor = K.Sequencer.playerButtonColors[1]
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
            track2Buttons[sender.tag].backgroundColor = K.Sequencer.playerButtonColors[2]
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
            track3Buttons[sender.tag].backgroundColor = K.Sequencer.playerButtonColors[3]
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
                
                button.backgroundColor = K.Sequencer.playerButtonColors[0]
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track1Buttons.enumerated() {
            
            if seq.tracks[1].cells[index] == .ON {
                
                button.backgroundColor = K.Sequencer.playerButtonColors[1]
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track2Buttons.enumerated() {
            
            if seq.tracks[2].cells[index] == .ON {
                
                button.backgroundColor = K.Sequencer.playerButtonColors[2]
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track3Buttons.enumerated() {
            
            if seq.tracks[3].cells[index] == .ON {
                
                button.backgroundColor = K.Sequencer.playerButtonColors[3]
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        
    }
    
    //
    // MARK:- Settings
    //
    @IBAction func settingsPressed(_ sender: UIButton) {
        
        print(#function)
    }
    
    //
    // MARK:- Change number of cells
    //
    @IBAction func changeNumberOfCells(_ sender: UIStepper) {
        print(#function)
        print(sender.tag, " ", sender.value)
        let selectedPlayer = sender.tag
        let newNumberOfCells = sender.value
        seq.tracks[selectedPlayer].numberOfCellsActive = Int(newNumberOfCells)
        
        //
        // Hide alle cells
        //
        for button in trackButtonMatrix[selectedPlayer] {
            button.isHidden = true
        }
        
        //
        // Show only active cells
        //
        for i in 0...(seq.tracks[selectedPlayer].numberOfCellsActive - 1) {
            trackButtonMatrix[selectedPlayer][i].isHidden = false
        }
        
        printFrameLengths()
        //loadBuffer(ofPlayer: selectedPlayer, withFile: selectedPlayer)
        
        loadAllBuffers()
        printFrameLengths()
        preScheduleFirstBuffer(forPlayer: 0)
        preScheduleFirstBuffer(forPlayer: 1)
        preScheduleFirstBuffer(forPlayer: 2)
        preScheduleFirstBuffer(forPlayer: 3)
        stopAndRestartAllTimers()
        
    }
      
    @objc func onDidReceiveData(_ notification: Notification) {
        print(#function)
        print(notification)
        print()
    }
    
    //
    // MARK:- Tempo changed, update UI Tempo Elements
    //
    private func updateUIAfterTempoChange(to newTempo: Double, restart: Bool? = true) {
        
        //
        // Set new tempo, display value, load new buffers
        //
        seq.tempo?.bpm = newTempo
        bpmLabel.text = String(seq.tempo!.bpm)
        
        //
        // Update stepper display
        //
        bpmStepper.value = seq.tempo!.bpm
  
        //
        // Update picker display
        //
        let leftSide = floor(newTempo)
        let rightSide = (newTempo - leftSide) * 10
        print("\(leftSide) \(rightSide)")
        picker.selectRow(Int(leftSide) - 30, inComponent: 0, animated: true) //
        picker.selectRow(0, inComponent: 1, animated: true) // decimal point
        picker.selectRow(Int(rightSide), inComponent: 2, animated: true) // start at 0 as decimal
        
        loadAllBuffers()

        stopAndRestartAllTimers()
    }
    
    func stopAndRestartAllTimers() {
        
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
            startAllTimers()
        }
        
    }
}

extension ViewController {
    
    func printFrameLengths() {
        
        print(self.soundBuffers[0].frameLength, self.silenceBuffers[0].frameLength, "  ",
              self.soundBuffers[1].frameLength, self.silenceBuffers[1].frameLength, "  ",
              self.soundBuffers[2].frameLength, self.silenceBuffers[2].frameLength, "  ",
              self.soundBuffers[3].frameLength, self.silenceBuffers[3].frameLength
              )
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
    
//    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0 {
//            return "\(Array(pickerLeftInts)[row])"
//        } else if component == 1 {
//            return "."
//        } else {
//            return "\(Array(pickerRightDecimals)[row])"
//        }
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Arial", size: 25)
            switch component {
            case 0:
                pickerLabel?.textAlignment = .right
            case 1:
                pickerLabel?.textAlignment = .center
            case 2:
                pickerLabel?.textAlignment = .left
            default:
                print("not gonna be the case for sure")
            }
        }
        pickerLabel?.text = pickerDataArray[component][row]
        pickerLabel?.textColor = UIColor(named: "Your Color Name")

        return pickerLabel!
    }
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 60
        } else if component == 1 {
            return 15
        } else if component == 2 {
            return 30
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
        seq.tempo?.bpm = newTempo
        updateUIAfterTempoChange(to: newTempo)
    }
}
