// using timer to schedule buffers
// https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer


import UIKit
import AVFoundation

fileprivate let DEBUG = false

class ViewController: UIViewController {
    
    //    let leftSwipeButton = UISwipeGestureRecognizer(target: self, action: "leftSwipeButtonAction:")
    //
    private var engine = AVAudioEngine()
    
    private var players = [AVAudioPlayerNode(), AVAudioPlayerNode(),
                           AVAudioPlayerNode(), AVAudioPlayerNode()]
    private var guidePlayer = AVAudioPlayerNode()
    
    private var reverbs = [AVAudioUnitReverb(), AVAudioUnitReverb(),
                           AVAudioUnitReverb(), AVAudioUnitReverb()]
    private var delays = [AVAudioUnitDelay(), AVAudioUnitDelay(),
                          AVAudioUnitDelay(), AVAudioUnitDelay()]
    private var mixer = AVAudioMixerNode()
    
    private var bpmDetector = BpmDetector()
    
    private let fileNameSilence = "silence.wav"
    
//    private let fileNames = FileNames(
//        normal: ["kick_2156samples.wav",
//                 "snare_2152samples.wav",
//                 "hihat_2154samples.wav",
//                 "open_hihat_2181samples.wav"],
//        soft: ["kick_2156samples_SOFT.wav",
//               "snare_2152samples_SOFT.wav",
//               "hihat_2154samples_SOFT.wav",
//               "open_hihat_2181samples_SOFT.wav"])
    private let fileNames = FileNames(
        normal: ["440KICK1.wav",
                 "440SN1.wav",
                 "hihat_2154samples.wav",
                 "440CRASH.wav"],
        soft: ["kick_2156samples_SOFT.wav",
               "snare_2152samples_SOFT.wav",
               "hihat_2154samples_SOFT.wav",
               "open_hihat_2181samples_SOFT.wav"])
   
    
    private var files = Files()
    
    private var fileSilence: AVAudioFile! = nil
    
    private var soundBuffers = SoundBuffers()
    private var silenceBuffers = [AVAudioPCMBuffer]()

    private var guideBuffer = AVAudioPCMBuffer()
    
    private var timerEventCounter0: Int = 1
    private var currentStep0: Int = 1
    private var timerEventCounter1: Int = 1
    private var currentStep1: Int = 1
    private var timerEventCounter2: Int = 1
    private var currentStep2: Int = 1
    private var timerEventCounter3: Int = 1
    private var currentStep3: Int = 1
    
    private var timerEventCounterGuide: Int = 1
    private var currentStepGuide: Int = 1
    
    private enum State {case run; case stop}
    private var state: State = .stop
    
    private var timer0: Timer! = nil
    private var timer1: Timer! = nil
    private var timer2: Timer! = nil
    private var timer3: Timer! = nil
    
    private var timerGuide: Timer! = nil
    
    private let pickerLeftInts = 30...300 // 271 elements
    private let pickerRightDecimals = 0...9 // 10 elements
    private let pickerDataArray = [Array(30...300).map{String($0)}, ["."], Array(0...9).map{String($0)}]
    private var pickedLeft: Int = 120
    private var pickedRight: Int = 0
    
    //
    // MARK: - OUTLETS
    //
    
    //
    // Track control labels
    //
    
    @IBOutlet weak var trackVolumeLabel: UILabel!
    @IBOutlet weak var trackReverbLabel: UILabel!
    @IBOutlet weak var trackStepsLabel: UILabel!
    @IBOutlet weak var trackMuteLabel: UILabel!
    @IBOutlet weak var trackCellsLabel: UILabel!
    @IBOutlet weak var trackCellsView: UIStackView!
    
    @IBOutlet weak var trackControlsLabelsStackView: UIStackView!
    private var trackControlLabels = [UILabel]()
    
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
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var bpmStepper: UIStepper!
    @IBOutlet weak var bpmStepperView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var partSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
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
    
    @IBOutlet weak var volumeSlider0: UISlider!
    @IBOutlet weak var volumeSlider1: UISlider!
    @IBOutlet weak var volumeSlider2: UISlider!
    @IBOutlet weak var volumeSlider3: UISlider!
    private var trackVolumeSliders = [UISlider]()
    
    @IBOutlet weak var reverbSlider0: UISlider!
    @IBOutlet weak var reverbSlider1: UISlider!
    @IBOutlet weak var reverbSlider2: UISlider!
    @IBOutlet weak var reverbSlider3: UISlider!
    private var trackReverbSliders = [UISlider]()
    
    @IBOutlet weak var delaySlider0: UISlider!
    @IBOutlet weak var delaySlider1: UISlider!
    @IBOutlet weak var delaySlider2: UISlider!
    @IBOutlet weak var delaySlider3: UISlider!
    private var trackDelaySliders = [UISlider]()
    
    private var trackSliders = [UISlider]()
    
    private var controlButtons: [UIView] = []
    
    var seq = Sequencer()
    
    var controlsHidden = true
    
    //    func leftSwipeButtonAction(recognizer:UITapGestureRecognizer) {
    //        //You could access to sender view
    //        print(recognizer.view)
    //    }
    
    //
    // MARK: - LIFECYCLE
    //
    override func viewDidLoad() {
        
        //        leftSwipeButton.direction = .left
        
        super.viewDidLoad()
        
        files = Files(normal: [AVAudioFile(), AVAudioFile(), AVAudioFile(), AVAudioFile()],
                      soft: [AVAudioFile(), AVAudioFile(), AVAudioFile(), AVAudioFile()])
        soundBuffers = SoundBuffers(normal: [AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer()], soft: [AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer()])
        
        silenceBuffers = [AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer(), AVAudioPCMBuffer()]
        
        // NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .AVAudioEngineConfigurationChange, object: nil)
        
        seq.tempo = Tempo(bpm: 120, sampleRate: K.Sequencer.sampleRate)
        
        seq.loadPattern(number: 0)
        
        print(seq.durationOf16thNoteInSamples(forTrack: 0))
        print(seq.durationOf16thNoteInSamples(forTrack: 1))
        print(seq.durationOf16thNoteInSamples(forTrack: 2))
        print(seq.durationOf16thNoteInSamples(forTrack: 3))
    
        
        // Connect data:
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(90, inComponent: 0, animated: true) // start at 120 bpm
        picker.selectRow(0, inComponent: 1, animated: true) // decimal point
        picker.selectRow(0, inComponent: 2, animated: true) // start at 0 as decimal
        
        trackControlLabels = [trackVolumeLabel, trackReverbLabel, /*, trackStepsLabel */ trackMuteLabel, trackCellsLabel]
        
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
        trackVolumeSliders = [volumeSlider0, volumeSlider1, volumeSlider2, volumeSlider3]
        trackReverbSliders = [reverbSlider0, reverbSlider1, reverbSlider2, reverbSlider3]
        trackDelaySliders = [delaySlider0, delaySlider1, delaySlider2, delaySlider3]
        trackSliders = trackVolumeSliders + trackReverbSliders + trackDelaySliders
        
        //players = [player0, player1, player2, player3]
        
        //
        // Style & hide all buttons
        //
        let allButtons = track0Buttons + track1Buttons + track2Buttons + track3Buttons
        for (index, button) in allButtons.enumerated() {
            print("Index: \(index)")
            //button.backgroundColor = .none
            button.layer.borderColor = K.Color.playerButtonBorderColors[0].cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = false
            button.titleLabel?.text = ""
            button.tag = index
            //button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
            //button.addGestureRecognizer(leftSwipeButton)
        }
        
        //
        // Hide track control labels
        //
        for label in trackControlLabels {
            label.isHidden = true
        }
        trackCellsView.isHidden = true
        trackControlsLabelsStackView.isHidden = true
        
        //
        // muteButtons
        //
        for (index, button) in muteButtons.enumerated() {
            //print("Index: \(index)")
            button.backgroundColor = K.Color.muteButtonColor
            button.layer.borderColor = K.Color.muteButtonBorderColor.cgColor
            button.layer.borderWidth = 1.0
            button.isHidden = false
            //            button.titleLabel?.text = "AA"
            button.setTitleColor(K.Color.black, for: .normal)
            button.layer.cornerRadius = 15
            // button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.tag = index
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
        }
        
        for view in stepperViews {
            view.backgroundColor = K.Color.muteButtonColor
        }
        for (index, stepper) in stepperButtons.enumerated() {
            stepper.backgroundColor = K.Color.muteButtonColor
            
            stepper.minimumValue = 1
            stepper.maximumValue = 16
            stepper.stepValue = 1
            stepper.tag = index
            stepper.value = Double(seq.tracks[index].numberOfCellsActive)
        }
        
        for (index, slider) in trackVolumeSliders.enumerated() {
            slider.tag = index
            slider.tintColor = K.Color.orange
        }
        for (index, slider) in trackReverbSliders.enumerated() {
            slider.tag = index
            slider.tintColor = K.Color.orange
            
        }
        for (index, slider) in trackDelaySliders.enumerated() {
            slider.tag = index
            slider.tintColor = K.Color.orange
            
        }
        
        settingsButton.backgroundColor = K.Color.orange
        settingsButton.tintColor = K.Color.black
        settingsButton.setTitleColor(K.Color.black, for: .normal)
        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.layer.cornerRadius = 15
        partSegmentedControl.backgroundColor = K.Color.controlButtonsColor
        partSegmentedControl.selectedSegmentTintColor = K.Color.controlButtonsSelectedColor
        
        
        for uielement in controlButtons{
            uielement.backgroundColor = .lightGray
            if let label = uielement as? UILabel {
                label.textColor = .white
                label.backgroundColor = K.Color.controlButtonsColor
            }
            if let button = uielement as? UIButton {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = K.Color.blue_brighter
                button.layer.cornerRadius = 0.125 * button.bounds.size.width
                
            }
            if let stepper = uielement as? UIStepper {
                //stepper.tintColor = .white
                stepper.backgroundColor = K.Color.controlButtonsColor
                stepper.layer.cornerRadius = 0.125 * stepper.bounds.size.width
                
            }
            if let picker = uielement as? UIPickerView {
                picker.tintColor = .white
                picker.backgroundColor = K.Color.controlButtonsColor
                picker.layer.cornerRadius = 0.125 * picker.bounds.size.width
            }
            tapButton.setTitleColor(.black, for: .normal)
            
        }
        
        
        updateUI()
        
        bpmStepper.minimumValue = 30
        bpmStepper.maximumValue = 300
        bpmStepper.stepValue = 1
        bpmStepper.value = seq.tempo!.bpm
        bpmLabel.text = String(seq.tempo!.bpm)
        bpmStepperView.backgroundColor = K.Color.controlButtonsColor
        bpmStepper.isHidden = true
        bpmStepperView.isHidden = true
        
        loadBuffer(ofPlayer: 0, withFile: 0)
        loadBuffer(ofPlayer: 1, withFile: 1)
        loadBuffer(ofPlayer: 2, withFile: 2)
        loadBuffer(ofPlayer: 3, withFile: 3)
        loadGuideBuffer()
        
        
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
        
        
        //        let format = reverb2.inputFormat(forBus: 0)
        //        engine.connect(players[1], to: reverb2, format: format)
        //        engine.connect(reverb2, to: engine.outputNode, format: format)
        
        
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
        
        
        //preScheduleFirstBuffer_OLD()
        preScheduleFirstBuffer(forPlayer: 0)
        preScheduleFirstBuffer(forPlayer: 1)
        preScheduleFirstBuffer(forPlayer: 2)
        preScheduleFirstBuffer(forPlayer: 3)
        preScheduleFirstGuideBuffer()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        showOrHideControls()
        
    }
    
    
    //
    // MARK:- Load buffers (with parameter)
    //
    func loadBuffer(ofPlayer player_to_be_loaded: Int, withFile file_to_load: Int) {
        
        //
        // MARK: Loading buffer - attached to player0 - TODO: file0 / file1 / ... will be made variable later!
        //
        let path_normal = Bundle.main.path(forResource: fileNames.normal[file_to_load], ofType: nil)!
        let path_soft = Bundle.main.path(forResource: fileNames.soft[file_to_load], ofType: nil)!
        //let path = Bundle.main.path(forResource: fileNames[file_to_load], ofType: nil)!
        
        let url_normal = URL(fileURLWithPath: path_normal)
        let url_soft = URL(fileURLWithPath: path_soft)
        
        do {
            files.normal[file_to_load] = try AVAudioFile(forReading: url_normal)
            soundBuffers.normal[player_to_be_loaded] = AVAudioPCMBuffer(
                pcmFormat: files.normal[file_to_load].processingFormat,
                frameCapacity: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded)))!
            
            files.soft[file_to_load] = try AVAudioFile(forReading: url_soft)
            soundBuffers.soft[player_to_be_loaded] = AVAudioPCMBuffer(
                pcmFormat: files.soft[file_to_load].processingFormat,
                frameCapacity: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded)))!
            
            try files.normal[file_to_load].read(into: soundBuffers.normal[player_to_be_loaded])
            try files.soft[file_to_load].read(into: soundBuffers.soft[player_to_be_loaded])
            
            soundBuffers.normal[player_to_be_loaded].frameLength = AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded))
            soundBuffers.soft[player_to_be_loaded].frameLength = AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded))
            
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
                frameCapacity: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded)))!
            try fileSilence.read(into: silenceBuffers[player_to_be_loaded])
            silenceBuffers[player_to_be_loaded].frameLength = AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded))
        } catch {
            print("Error loading buffer0 \(player_to_be_loaded) \(error)")
        }
        
        
    }
    
    //
    // MARK:- Load guide buffers (with parameter)
    //
    func loadGuideBuffer() {
        
        //
        // MARK: Loading buffer - attached to player0 - TODO: file0 / file1 / ... will be made variable later!
        //
        let path = Bundle.main.path(forResource: fileNameSilence, ofType: nil)!
        
        let url = URL(fileURLWithPath: path)
        
        do {
            guideBuffer = AVAudioPCMBuffer(
                pcmFormat: fileSilence.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: 0)))!
            
            try fileSilence.read(into: guideBuffer)
            
            guideBuffer.frameLength = AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: 0))
            
        } catch { print("Error loading guide buffer ") }
    
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
            preScheduleFirstGuideBuffer()
            
            updateUIAfterTempoChange(to: newTempo, restart: true)
            print(newTempo)
            
        }
    }
    
    //
    // MARK:- Part changed
    //
    
    @IBAction func partChanged(_ sender: UISegmentedControl) {
        
        print(#function)
        seq.saveToPattern(number: seq.activePattern)
        print(partSegmentedControl.selectedSegmentIndex)
        seq.loadPattern(number: partSegmentedControl.selectedSegmentIndex)
        seq.activePattern = partSegmentedControl.selectedSegmentIndex
        updateUI()
    }
    
    
    
    //
    // MARK:- Stepper action
    //
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        let newTempo = bpmStepper.value
        seq.tempo?.bpm = newTempo
        
        preScheduleFirstBuffer(forPlayer: 0)
        preScheduleFirstBuffer(forPlayer: 1)
        preScheduleFirstBuffer(forPlayer: 2)
        preScheduleFirstBuffer(forPlayer: 3)
        preScheduleFirstGuideBuffer()
        
        updateUIAfterTempoChange(to: newTempo)
    }
    
    //
    // MARK:- Play / Pause toggle action
    //
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        
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
            preScheduleFirstGuideBuffer()
            
            
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
            print(soundBuffers.normal[0].frameLength, soundBuffers.normal[1].frameLength, soundBuffers.normal[2].frameLength, soundBuffers.normal[3].frameLength)
        }
        
        //
        //  Timer for player0
        //
        let timerIntervallInSeconds0 = self.seq.durationOf16thNoteInSamples(forTrack: 0) / (2 * K.Sequencer.sampleRate) // 1/2 of 16th note in seconds
        timer0 = Timer.scheduledTimer(withTimeInterval: timerIntervallInSeconds0, repeats: true) { timer in
            
            //
            // Compute & dump debug values
            //
            // Values at begin of timer event
            var currentTime = round(self.players[0].currentTimeInSeconds, toDigits: 3)
            
            print(#function)
            
            print(self.soundBuffers.normal[0].frameLength, self.silenceBuffers[0].frameLength, "  ",
                  self.soundBuffers.normal[1].frameLength, self.silenceBuffers[1].frameLength, "  ",
                  self.soundBuffers.normal[2].frameLength, self.silenceBuffers[2].frameLength, "  ",
                  self.soundBuffers.normal[3].frameLength, self.silenceBuffers[3].frameLength
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
                    self.players[0].scheduleBuffer(self.soundBuffers.normal[0], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer0"
                } else if nextCell == .SOFT {
                    self.players[0].scheduleBuffer(self.soundBuffers.soft[0], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer0 soft"
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
        let timerIntervallInSeconds1 = self.seq.durationOf16thNoteInSamples(forTrack: 1) / (2 * K.Sequencer.sampleRate)
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
                    self.players[1].scheduleBuffer(self.soundBuffers.normal[1], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer1"
                } else if nextCell == .SOFT {
                    self.players[1].scheduleBuffer(self.soundBuffers.soft[1], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer1 soft"
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
        let timerIntervallInSeconds2 = self.seq.durationOf16thNoteInSamples(forTrack: 2) / (2 * K.Sequencer.sampleRate)
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
                    self.players[2].scheduleBuffer(self.soundBuffers.normal[2], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer2"
                } else if nextCell == .SOFT {
                    self.players[2].scheduleBuffer(self.soundBuffers.soft[2], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer2 soft"
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
        let timerIntervallInSeconds3 = self.seq.durationOf16thNoteInSamples(forTrack: 3) / (2 * K.Sequencer.sampleRate)
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
                    self.players[3].scheduleBuffer(self.soundBuffers.normal[3], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer3"
                } else if nextCell == .SOFT {
                    self.players[3].scheduleBuffer(self.soundBuffers.soft[3], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer3 soft"
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
            players[seletedPlayer].scheduleBuffer(soundBuffers.normal[seletedPlayer], at: nil, options: [], completionHandler: nil)
        } else {
            //
            // Schedule silence
            //
            players[seletedPlayer].scheduleBuffer(silenceBuffers[seletedPlayer], at: nil, options: [], completionHandler: nil)
        }
        players[seletedPlayer].prepare(withFrameCount: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: seletedPlayer)))
    }
    
    
    private func preScheduleFirstGuideBuffer() {
        
        print(#function)
        
        printFrameLengths()
        
        guidePlayer.stop()
        
        //
        // Schedule silence
        //
        
            guidePlayer.scheduleBuffer(guideBuffer, at: nil, options: [], completionHandler: nil)

        guidePlayer.prepare(withFrameCount: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: 0)))
    }
    
    //
    // MARK:- cellPressed
    //
    @IBAction func cellPressed(_ sender: UIButton) {
        
        var selectedTrack = 0
        //        while !trackButtonMatrix[selectedTrack].contains(sender) {selectedTrack += 1}
        
        var numberOfCell: Int = 0
        switch sender.tag {
        case 0...15: selectedTrack = 0; numberOfCell = sender.tag
        case 16...31: selectedTrack = 1; numberOfCell = sender.tag - 16
        case 32...47: selectedTrack = 2; numberOfCell = sender.tag - 32
        case 48...63: selectedTrack = 3; numberOfCell = sender.tag - 48
        default: selectedTrack = 99 // will not happen
        }
        print("You pressed a buton in row: ", selectedTrack)
        
        
        if trackButtonMatrix[selectedTrack][numberOfCell].backgroundColor == .none {
            
            //
            // Step is OFF: Set Step
            //
            trackButtonMatrix[selectedTrack][numberOfCell].backgroundColor = K.Color.step
            seq.tracks[selectedTrack].cells[numberOfCell] = .ON
            
        } else if trackButtonMatrix[selectedTrack][numberOfCell].backgroundColor == K.Color.step {
            
            //
            // Step is ON: Set Step to SOFT
            //
            trackButtonMatrix[selectedTrack][numberOfCell].backgroundColor = K.Color.step_soft
            seq.tracks[selectedTrack].cells[numberOfCell] = .SOFT
            
        } else {
            
            //
            // Step is SOFT: Set Step to OFF
            //
            trackButtonMatrix[selectedTrack][numberOfCell].backgroundColor = .none
            seq.tracks[selectedTrack].cells[numberOfCell] = .OFF
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
            players[sender.tag].volume = Float(seq.tracks[sender.tag].volume)
            muteButtons[sender.tag].backgroundColor = K.Color.muteButtonColor
            
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
                
                button.backgroundColor = K.Color.step
                
            } else if seq.tracks[0].cells[index] == .SOFT {
                
                button.backgroundColor = K.Color.step_soft
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track1Buttons.enumerated() {
            
            if seq.tracks[1].cells[index] == .ON {
                
                button.backgroundColor = K.Color.step
                
            } else if seq.tracks[1].cells[index] == .SOFT {
                
                button.backgroundColor = K.Color.step_soft
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track2Buttons.enumerated() {
            
            if seq.tracks[2].cells[index] == .ON {
                
                button.backgroundColor = K.Color.step
                
            } else if seq.tracks[2].cells[index] == .SOFT {
                
                button.backgroundColor = K.Color.step_soft
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track3Buttons.enumerated() {
            
            if seq.tracks[3].cells[index] == .ON {
                
                button.backgroundColor = K.Color.step
                
            } else if seq.tracks[3].cells[index] == .SOFT {
                
                button.backgroundColor = K.Color.step_soft
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        
        //
        // Set Vol / Rev / Delay sliders to values in tracks Array
        //
        for (index, slider) in trackVolumeSliders.enumerated() {
            slider.value = Float(seq.tracks[index].volume)
        }
        for (index, slider) in trackReverbSliders.enumerated() {
            slider.value = Float(seq.tracks[index].reverbMix)
        }
        for (index, slider) in trackDelaySliders.enumerated() {
            slider.value = Float(seq.tracks[index].delayMix)
        }
        
    }
    
    //
    // MARK:- Settings
    //
    @IBAction func showControlsToggle(_ sender: UIButton?) {
        
        print(#function)
        controlsHidden = !controlsHidden
        showOrHideControls()
    }
    
    private func showOrHideControls() {
        
        if !controlsHidden {
            //
            // Show controls
            //
            for label in trackControlLabels {
                label.isHidden = false
            }
            trackCellsView.isHidden = false
            trackControlsLabelsStackView.isHidden = false
            
            for slider in trackVolumeSliders {
                slider.isHidden = false
            }
            for slider in trackReverbSliders {
                slider.isHidden = false
            }
            for slider in trackDelaySliders {
                slider.isHidden = false
            }
            //            for view in stepperViews {
            //                view.isHidden = false
            //            }
        } else {
            //
            // Hide controls
            //
            for label in trackControlLabels {
                label.isHidden = true
            }
            trackCellsView.isHidden = true
            trackControlsLabelsStackView.isHidden = true
            
            for slider in trackVolumeSliders {
                slider.isHidden = true
            }
            for slider in trackReverbSliders {
                slider.isHidden = true
            }
            for slider in trackDelaySliders {
                slider.isHidden = true
            }
            //            for view in stepperViews {
            //                view.isHidden = true
            //            }
            
            
        }
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
    
    //
    // MARK:- trackVolumeChanged()
    //
    @IBAction func trackVolumeChanged(_ sender: UISlider) {
        print(#function)
        print(sender.tag, sender.value)
        
        //
        // Write new volume to seq struct
        //
        seq.tracks[sender.tag].volume = Double(sender.value)
        
        //
        // Only change player volume if not muted
        //
        if !seq.tracks[sender.tag].muted {
            players[sender.tag].volume = sender.value}
        
        
        
    }
    
    //
    // MARK:- trackReverbChanged()
    //
    @IBAction func trackReverbChanged(_ sender: UISlider) {
        print(#function)
        print(sender.tag, sender.value)
        seq.tracks[sender.tag].reverbMix = Double(sender.value * 100)
        reverbs[sender.tag].wetDryMix = sender.value * 100
    }
    
    //
    // MARK:- trackDelayChanged()
    //
    @IBAction func trackDelayChanged(_ sender: UISlider) {
        print(#function)
        print(sender.tag, sender.value)
        seq.tracks[sender.tag].delayMix = Double(sender.value * 100)
        delays[sender.tag].wetDryMix = sender.value * 100
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
        //bpmLabel.text = String(seq.tempo!.bpm)
        
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
        
        //
        // Recalculate delay time (to dotted 8th note)
        //
        print("Delay old: ", delays[0].delayTime)
        let newDelayTime = 60.0 / seq.tempo!.bpm * 0.75
        for delay in delays {
            delay.delayTime = newDelayTime
        }
        print("Delay new: ", delays[0].delayTime)
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
        
        print(self.soundBuffers.normal[0].frameLength, self.silenceBuffers[0].frameLength, "  ",
              self.soundBuffers.normal[1].frameLength, self.silenceBuffers[1].frameLength, "  ",
              self.soundBuffers.normal[2].frameLength, self.silenceBuffers[2].frameLength, "  ",
              self.soundBuffers.normal[3].frameLength, self.silenceBuffers[3].frameLength, "  ",
              self.guideBuffer.frameLength
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
        
        preScheduleFirstBuffer(forPlayer: 0)
        preScheduleFirstBuffer(forPlayer: 1)
        preScheduleFirstBuffer(forPlayer: 2)
        preScheduleFirstBuffer(forPlayer: 3)
        
        updateUIAfterTempoChange(to: newTempo)
    }
}
