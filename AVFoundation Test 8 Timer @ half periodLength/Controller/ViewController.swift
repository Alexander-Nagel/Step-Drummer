// using timer to schedule buffers
// https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer


import UIKit
import AVFoundation

fileprivate let DEBUG = false

class ViewController: UIViewController {
    
    var seq = Sequencer()
    
    var controlsHidden = false
    var drawSoftNotes = false
    var copyMode = false
    var copyModeSource: PartNames?
    var deleteMode = false
    var deleteModeSource: PartNames?
    
    private var isSwiping = false
    private var swipeStart: Int?
    private var swipeStartMinY: CGFloat?
    private var swipeStartMaxY: CGFloat?
    private var swipeCellState: Cell?
    
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
    
    
    // MARK:-  OUTLETS
    //
    // Track control description labels
    //
    @IBOutlet weak var trackVolumeLabel: UILabel!
    @IBOutlet weak var trackReverbLabel: UILabel!
    @IBOutlet weak var trackDelayLabel: UILabel!
    @IBOutlet weak var trackStepsLabel: UILabel!
    @IBOutlet weak var trackMuteLabel: UILabel!
    @IBOutlet weak var trackCellsLabel: UILabel!
    @IBOutlet weak var trackCellsView: UIStackView!
    @IBOutlet weak var trackControlsLabelsStackView: UIStackView!
     var trackControlLabels = [UILabel]()
    
    //
    // player0 steps
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
     var track0Buttons: [UIButton] = []
    @IBOutlet weak var track0StackView: UIStackView!
    
    //
    // player1 steps
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
     var track1Buttons: [UIButton] = []
    
    //
    // player2 steps
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
     var track2Buttons: [UIButton] = []
    
    //
    // player3 steps
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
     var track3Buttons: [UIButton] = []
     var trackButtonMatrix: [[UIButton]] = []
    
    //
    // Track controls
    //
    @IBOutlet weak var mute0Button: UIButton!
    @IBOutlet weak var mute1Button: UIButton!
    @IBOutlet weak var mute2Button: UIButton!
    @IBOutlet weak var mute3Button: UIButton!
     var muteButtons: [UIButton] = []
    @IBOutlet weak var stepper0Button: UIStepper!
    @IBOutlet weak var stepper1Button: UIStepper!
    @IBOutlet weak var stepper2Button: UIStepper!
    @IBOutlet weak var stepper3Button: UIStepper!
     var stepperButtons: [UIStepper] = []
    @IBOutlet weak var stepper0View: UIView!
    @IBOutlet weak var stepper1View: UIView!
    @IBOutlet weak var stepper2View: UIView!
    @IBOutlet weak var stepper3View: UIView!
     var stepperViews: [UIView] = []
    @IBOutlet weak var volumeSlider0: UISlider!
    @IBOutlet weak var volumeSlider1: UISlider!
    @IBOutlet weak var volumeSlider2: UISlider!
    @IBOutlet weak var volumeSlider3: UISlider!
     var trackVolumeSliders = [UISlider]()
    @IBOutlet weak var reverbSlider0: UISlider!
    @IBOutlet weak var reverbSlider1: UISlider!
    @IBOutlet weak var reverbSlider2: UISlider!
    @IBOutlet weak var reverbSlider3: UISlider!
     var trackReverbSliders = [UISlider]()
    @IBOutlet weak var delaySlider0: UISlider!
    @IBOutlet weak var delaySlider1: UISlider!
    @IBOutlet weak var delaySlider2: UISlider!
    @IBOutlet weak var delaySlider3: UISlider!
     var trackDelaySliders = [UISlider]()
     var trackSliders = [UISlider]()
        
    //
    // Main Controls at bottom (Play, Tap, Parts...)
    //
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var partSegmentedControl: UISegmentedControl!
    @IBOutlet weak var softModeButton: VerticalButton!
    @IBOutlet weak var deleteButton: VerticalButton!
    @IBOutlet weak var copyButton: VerticalButton!
    
    @IBOutlet weak var chainButton: UIButton!
    //@IBOutlet weak var bpmLabel: UILabel!
    //@IBOutlet weak var bpmStepper: UIStepper!
    //@IBOutlet weak var bpmStepperView: UIView!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var playPauseButton: UIButton!

     var controlButtons: [UIView] = []
     
    let pickerLeftInts = 30...300 // 271 elements
    let pickerRightDecimals = 0...9 // 10 elements
    let pickerDataArray = [Array(30...300).map{String($0)}, ["."], Array(0...9).map{String($0)}]
    var pickedLeft: Int = 120
    var pickedRight: Int = 0
   
    //
    // MARK:- Life cycle
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI() // one time setup
    
        updateUI()
        
        loadBuffer(ofPlayer: 0, withFile: 0)
        loadBuffer(ofPlayer: 1, withFile: 1)
        loadBuffer(ofPlayer: 2, withFile: 2)
        loadBuffer(ofPlayer: 3, withFile: 3)
        loadGuideBuffer()
    
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
        let path_normal = Bundle.main.path(forResource: seq.fileNames.normal[file_to_load], ofType: nil)!
        let path_soft = Bundle.main.path(forResource: seq.fileNames.soft[file_to_load], ofType: nil)!
        //let path = Bundle.main.path(forResource: fileNames[file_to_load], ofType: nil)!
        
        let url_normal = URL(fileURLWithPath: path_normal)
        let url_soft = URL(fileURLWithPath: path_soft)
        
        do {
            seq.files.normal[file_to_load] = try AVAudioFile(forReading: url_normal)
            seq.soundBuffers.normal[player_to_be_loaded] = AVAudioPCMBuffer(
                pcmFormat: seq.files.normal[file_to_load].processingFormat,
                frameCapacity: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded)))!
            
            seq.files.soft[file_to_load] = try AVAudioFile(forReading: url_soft)
            seq.soundBuffers.soft[player_to_be_loaded] = AVAudioPCMBuffer(
                pcmFormat: seq.files.soft[file_to_load].processingFormat,
                frameCapacity: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded)))!
            
            try seq.files.normal[file_to_load].read(into: seq.soundBuffers.normal[player_to_be_loaded])
            try seq.files.soft[file_to_load].read(into: seq.soundBuffers.soft[player_to_be_loaded])
            
            seq.soundBuffers.normal[player_to_be_loaded].frameLength = AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded))
            seq.soundBuffers.soft[player_to_be_loaded].frameLength = AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded))
            
        } catch { print("Error loading buffer \(player_to_be_loaded) \(error)") }
        
        
        //
        // MARK: Loading silence buffer
        //
        let pathSilence = Bundle.main.path(forResource: seq.fileNameSilence, ofType: nil)!
        let urlSilence = URL(fileURLWithPath: pathSilence)
        do {
            seq.fileSilence = try AVAudioFile(forReading: urlSilence)
            seq.silenceBuffers[player_to_be_loaded] = AVAudioPCMBuffer(
                pcmFormat: seq.fileSilence.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded)))!
            try seq.fileSilence.read(into: seq.silenceBuffers[player_to_be_loaded])
            seq.silenceBuffers[player_to_be_loaded].frameLength = AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: player_to_be_loaded))
        } catch {
            print("Error loading buffer0 \(player_to_be_loaded) \(error)")
        }
        
        
    }
    
    //
    // MARK:- LOAD GUIDE BUFFER
    //
    func loadGuideBuffer() {
        
        //
        // MARK: Loading buffer - attached to player0 - TODO: file0 / file1 / ... will be made variable later!
        //
        let path = Bundle.main.path(forResource: seq.fileNameSilence, ofType: nil)!
        
        let url = URL(fileURLWithPath: path)
        
        do {
            seq.guideBuffer = AVAudioPCMBuffer(
                pcmFormat: seq.fileSilence.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: 0)))!
            
            try seq.fileSilence.read(into: seq.guideBuffer)
            
            seq.guideBuffer.frameLength = AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: 0))
            
        } catch { print("Error loading guide buffer ") }
        
    }
    
    //
    // MARK:- SOFT edit mode action
    //
    @IBAction func softModeButtonPressed(_ sender: UIButton) {
        print(#function)
        
        sender.isSelected = !sender.isSelected
        
        if drawSoftNotes {
            //
            // switch soft note mode OFF
            //
            drawSoftNotes = false
            //chainButton.setImage(UIImage(systemName: K.Image.playImage), for: .normal)
            softModeButton.backgroundColor = K.Color.blue
        } else {
            //
            // switch soft note mode  ON
            //
            drawSoftNotes = true
            //chainButton.setImage(UIImage(systemName: K.Image.pauseImage), for: .normal)
            softModeButton.backgroundColor = K.Color.blue_brightest
        }
    }
    
    //
    // MARK:- DELETE action
    //
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        print(#function)
        
        sender.isSelected = !sender.isSelected
        
        if deleteMode {
            //
            // switch deleteMode OFF
            //
            
            endDeleteMode()

        } else {
            //
            // switch deleteMode ON
            //
            deleteMode = true
            deleteModeSource = seq.activePart
            deleteButton.backgroundColor = K.Color.blue_brightest
            deleteButton.flashPermanently()
            
            //
            // Let inactive part buttons flash
            
            //
            partSegmentedControl.flashPermanently()
        }
        
//        //let activePart =
//        let ac = UIAlertController(title: "Delete Part \(seq.activePart)?", message: "This will delete all 4 tracks of the current part.", preferredStyle: .alert)
//        //ac.addTextField()
//
//        let deleteAction = UIAlertAction(title: "Delete", style: .default) { [unowned ac] _ in
//
//            self.seq.deletePart(partName: self.seq.activePart)
//            self.seq.loadPart(partName: self.seq.activePart)
//            self.updateUI()
//            print("Deleting")
//
//        }
//
//        ac.addAction(deleteAction)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { [unowned ac] _ in
//
//       }
//        ac.addAction(cancelAction)
//
//        present(ac, animated: true)
        
    }
    
    func endDeleteMode() {
        
        deleteMode = false
        deleteButton.backgroundColor = K.Color.blue_brighter
        deleteButton.layer.removeAllAnimations()
        partSegmentedControl.layer.removeAllAnimations()
        if let sourcePart = deleteModeSource {
            changeToPart(sourcePart)
        }
    }
    
    func endCopyMode() {
        
        copyMode = false
        copyButton.backgroundColor = K.Color.blue_brighter
        copyButton.layer.removeAllAnimations()
        partSegmentedControl.layer.removeAllAnimations()
        if let sourcePart = copyModeSource {
            changeToPart(sourcePart)
        }
    }
    
    //
    // MARK:- COPY action
    //
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        print(#function)
        
        sender.isSelected = !sender.isSelected
        
        if copyMode {
            //
            // switch copyMode OFF
            //
            
            endCopyMode()

        } else {
            //
            // switch copyMode ON
            //
            copyMode = true
            copyModeSource = seq.activePart
            copyButton.backgroundColor = K.Color.blue_brightest
            copyButton.flashPermanently()
            
            //
            // Let inactive part buttons flash
            
            //
            partSegmentedControl.flashPermanently()
        }
    }
    
    //
    // MARK:- CHAIN button action
    //
    @IBAction func chainButtonPressed(_ sender: UIButton) {
        print(#function)
        
        sender.isSelected = !sender.isSelected
        
        let current = seq.chainMode
        let next = current.next()
        
        seq.chainMode = next
        if next == .OFF {       // color OFF
            chainButton.backgroundColor = K.Color.blue_brighter
        } else {                // color chain mode ON
            chainButton.backgroundColor = K.Color.blue_brightest
        }
        print(next)
        print(next.description)
        chainButton.setTitle(next.description, for: .normal)
        
//        if seq.chainModeABCD != .OFF {
//            //
//            // switch chain mode OFF
//            //
//            seq.chainModeABCD = .OFF
//            //chainButton.setImage(UIImage(systemName: K.Image.playImage), for: .normal)
//            chainButton.backgroundColor = K.Color.blue_brighter
//        } else {
//            //
//            // switch chain mode ON / progress to next mode
//            //
//            seq.chainModeABCD = .ABCD
//            //chainButton.setImage(UIImage(systemName: K.Image.pauseImage), for: .normal)
//            chainButton.backgroundColor = K.Color.blue_brightest
//        }
    }
    
    //
    // MARK:- TAP BUTTON action
    //
    @IBAction func tapButtonPressed(_ sender: UIButton) {
        
        tapButton.flash(intervalDuration: 0.05, intervals: 1)
        
        let newTempo = seq.bpmDetector.tapReceived()
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
        
        let destinationPart = PartNames(rawValue: partSegmentedControl.selectedSegmentIndex)!
        
        if !copyMode && !deleteMode {
            //
            // Normal behaviour when not in copyMode or deleteMode: Switch to destinationPart
            //
            seq.saveToPart(partName: seq.activePart)
            print(partSegmentedControl.selectedSegmentIndex)
            seq.loadPart(partName: destinationPart)
            seq.activePart = destinationPart
            updateUI()
        } else if copyMode {
            //
            // When in copyMode: Copy displayedPart to destinationPart, do NOT switch
            //
            seq.copyActivePart(to: destinationPart)
            
            endCopyMode()
            
            if let source = copyModeSource {
                let copyCompleteAlert = UIAlertController(title: "Copied Part \(source) to \(destinationPart)", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { [unowned copyCompleteAlert] _ in }
                copyCompleteAlert.addAction(action)
                present(copyCompleteAlert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    copyCompleteAlert.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            //
            // When in deleteMode: Delete displayedPart , do NOT switch
            //
            print("will be deleting part \(destinationPart)")
            self.seq.deletePart(partName: destinationPart)
            if self.seq.activePart == destinationPart {
                self.seq.loadPart(partName: destinationPart)
            }
            self.updateUI()
            
            endDeleteMode()
            
            let deleteCompleteAlert = UIAlertController(title: "Part \(destinationPart) deleted!", message: nil, preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "OK", style: .default) { [unowned deleteCompleteAlert] _ in }
            deleteCompleteAlert.addAction(deleteAction)
            present(deleteCompleteAlert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                deleteCompleteAlert.dismiss(animated: true, completion: nil)
            }
        
            
        }
        
        
    }
    
    //
    // MARK:- CHANGE TO PART
    //
    func changeToPart(_ partName: PartNames) {
        print(#function)
        seq.saveToPart(partName: seq.activePart)
        //print(partSegmentedControl.selectedSegmentIndex)
        seq.loadPart(partName: partName)
        seq.activePart = partName
        partSegmentedControl.selectedSegmentIndex = partName.rawValue
        updateUI()
    }
    
    
    
    //
    // MARK:- Stepper action
    //
//    @IBAction func stepperPressed(_ sender: UIStepper) {
//
//        let newTempo = bpmStepper.value
//        seq.tempo?.bpm = newTempo
//
//        preScheduleFirstBuffer(forPlayer: 0)
//        preScheduleFirstBuffer(forPlayer: 1)
//        preScheduleFirstBuffer(forPlayer: 2)
//        preScheduleFirstBuffer(forPlayer: 3)
//        preScheduleFirstGuideBuffer()
//
//        updateUIAfterTempoChange(to: newTempo)
//    }
    
    //
    // MARK:- PLAY / PAUSE button action
    //
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if state == .run {
            
            //
            // Stop!
            //
            state = .stop
            playPauseButton.setImage(UIImage(systemName: K.Image.playImage), for: .normal)
            playPauseButton.backgroundColor = K.Color.blue_brighter

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
            playPauseButton.backgroundColor = K.Color.blue_brightest
            
            startPlayers()
            
            startAllTimers()
        }
    }
    
    //
    // START ALL TIMERS
    //
    fileprivate func startAllTimers() {
        
        if DEBUG {
            print("# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  ")
            print(seq.soundBuffers.normal[0].frameLength, seq.soundBuffers.normal[1].frameLength, seq.soundBuffers.normal[2].frameLength, seq.soundBuffers.normal[3].frameLength)
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
            var currentTime = round(self.seq.players[0].currentTimeInSeconds, toDigits: 3)
            
            print(#function)
            
            print(self.seq.soundBuffers.normal[0].frameLength, self.seq.silenceBuffers[0].frameLength, "  ",
                  self.seq.soundBuffers.normal[1].frameLength, self.seq.silenceBuffers[1].frameLength, "  ",
                  self.seq.soundBuffers.normal[2].frameLength, self.seq.silenceBuffers[2].frameLength, "  ",
                  self.seq.soundBuffers.normal[3].frameLength, self.seq.silenceBuffers[3].frameLength
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
                if nextStep == self.seq.displayedTracks[0].numberOfCellsActive {
                    nextStep = 0
                }
                let nextCell = self.seq.displayedTracks[0].cells[nextStep]
                
                if nextCell == .ON {
                    self.seq.players[0].scheduleBuffer(self.seq.soundBuffers.normal[0], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer0"
                } else if nextCell == .SOFT {
                    self.seq.players[0].scheduleBuffer(self.seq.soundBuffers.soft[0], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer0 soft"
                } else {
                    
                    self.seq.players[0].scheduleBuffer(self.seq.silenceBuffers[0], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer0Silence"
                }
            } else {
                //
                // EVEN event: increase stepCounter
                //
                self.currentStep0 += 1
                if self.currentStep0 > self.seq.displayedTracks[0].numberOfCellsActive {
                    self.currentStep0 = 1
                    
                    if self.seq.chainMode == .ABCD {
                        var nextPart = self.seq.activePart.rawValue + 1
                        if nextPart == 4 { nextPart = 0 }
                        self.changeToPart(PartNames(rawValue: nextPart)!)
                    }
                    if self.seq.chainMode == .AB {
                        let currentPart = self.seq.activePart
                        var nextPart: PartNames
                        if currentPart == .A {
                            nextPart = .B
                        } else {
                            nextPart = .A
                        }
                        self.changeToPart(nextPart)
                    }
                    if self.seq.chainMode == .CD {
                        let currentPart = self.seq.activePart
                        var nextPart: PartNames
                        if currentPart == .C {
                            nextPart = .D
                        } else {
                            nextPart = .C
                        }
                        self.changeToPart(nextPart)
                    }
                    if self.seq.chainMode == .AD {
                        let currentPart = self.seq.activePart
                        var nextPart: PartNames
                        if currentPart == .A {
                            nextPart = .D
                        } else {
                            nextPart = .A
                        }
                        self.changeToPart(nextPart)
                    }
                    if self.seq.chainMode == .CB {
                        let currentPart = self.seq.activePart
                        var nextPart: PartNames
                        if currentPart == .C {
                            nextPart = .B
                        } else {
                            nextPart = .C
                        }
                        self.changeToPart(nextPart)
                    }
                    if self.seq.chainMode == .ABC {
                        let currentPart = self.seq.activePart
                        var nextPart: PartNames
                        if currentPart == .A {
                            nextPart = .B
                        } else if currentPart == .B{
                            nextPart = .C
                        } else {
                            nextPart = .A
                        }
                        self.changeToPart(nextPart)
                    }
                    
                    
                }
            }
            
            //
            // Increase timerEventCounter, two events per beat.
            //
            self.timerEventCounter0 += 1
            
            if self.timerEventCounter0 > (self.seq.displayedTracks[0].numberOfCellsActive * 2) {
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
                currentTime = round(self.seq.players[0].currentTimeInSeconds, toDigits: 3)
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
            var currentTime = round(self.seq.players[1].currentTimeInSeconds, toDigits: 3)
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
                if nextStep == self.seq.displayedTracks[1].numberOfCellsActive {
                    nextStep = 0
                }
                let nextCell = self.seq.displayedTracks[1].cells[nextStep]
                
                if nextCell == .ON {
                    self.seq.players[1].scheduleBuffer(self.seq.soundBuffers.normal[1], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer1"
                } else if nextCell == .SOFT {
                    self.seq.players[1].scheduleBuffer(self.seq.soundBuffers.soft[1], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer1 soft"
                } else {
                    self.seq.players[1].scheduleBuffer(self.seq.silenceBuffers[1], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer1Silence"
                }
            } else {
                //
                // increase stepCounter
                //
                self.currentStep1 += 1
                if self.currentStep1 > self.seq.displayedTracks[1].numberOfCellsActive {
                    self.currentStep1 = 1
                }
            }
            
            //
            // Increase timerEventCounter, two events per beat.
            //
            self.timerEventCounter1 += 1
            
            if self.timerEventCounter1 > (self.seq.displayedTracks[1].numberOfCellsActive * 2) {
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
                currentTime = round(self.seq.players[1].currentTimeInSeconds, toDigits: 3)
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
            var currentTime = round(self.seq.players[2].currentTimeInSeconds, toDigits: 3)
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
                if nextStep == self.seq.displayedTracks[2].numberOfCellsActive {
                    nextStep = 0
                }
                let nextCell = self.seq.displayedTracks[2].cells[nextStep]
                
                if nextCell == .ON {
                    self.seq.players[2].scheduleBuffer(self.seq.soundBuffers.normal[2], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer2"
                } else if nextCell == .SOFT {
                    self.seq.players[2].scheduleBuffer(self.seq.soundBuffers.soft[2], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer2 soft"
                } else {
                    self.seq.players[2].scheduleBuffer(self.seq.silenceBuffers[2], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer2Silence"
                }
            } else {
                //
                // increase stepCounter
                //
                self.currentStep2 += 1
                if self.currentStep2 > self.seq.displayedTracks[2].numberOfCellsActive {
                    self.currentStep2 = 1
                }
            }
            
            //
            // Increase timerEventCounter, two events per beat.
            //
            self.timerEventCounter2 += 1
            
            if self.timerEventCounter2 > (self.seq.displayedTracks[2].numberOfCellsActive * 2) {
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
                currentTime = round(self.seq.players[2].currentTimeInSeconds, toDigits: 3)
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
            var currentTime = round(self.seq.players[3].currentTimeInSeconds, toDigits: 3)
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
                if nextStep == self.seq.displayedTracks[3].numberOfCellsActive {
                    nextStep = 0
                }
                let nextCell = self.seq.displayedTracks[3].cells[nextStep]
                
                if nextCell == .ON {
                    self.seq.players[3].scheduleBuffer(self.seq.soundBuffers.normal[3], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer3"
                } else if nextCell == .SOFT {
                    self.seq.players[3].scheduleBuffer(self.seq.soundBuffers.soft[3], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer3 soft"
                } else {
                    self.seq.players[3].scheduleBuffer(self.seq.silenceBuffers[3], at: nil, options: [], completionHandler: nil)
                    bufferScheduled = "buffer3Silence"
                }
            } else {
                //
                // increase stepCounter
                //
                self.currentStep3 += 1
                if self.currentStep3 > self.seq.displayedTracks[3].numberOfCellsActive {
                    self.currentStep3 = 1
                }
            }
            
            //
            // Increase timerEventCounter, two events per beat.
            //
            self.timerEventCounter3 += 1
            
            if self.timerEventCounter3 > (self.seq.displayedTracks[3].numberOfCellsActive * 2) {
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
                currentTime = round(self.seq.players[3].currentTimeInSeconds, toDigits: 3)
                print("Exiting \ttimerEvent: \(self.timerEventCounter3) \tstep: \(self.currentStep3) \tcurrTime: \(currentTime) \t\(bufferScheduled)")
                print()
            }
        }
        
        
    }
    
    //
    // MARK:- START PLAYERS
    //
    private func startPlayers() {
        
        for player in seq.players {
            player.play()
        }
    }
    
    //
    // MARK:- LOAD ALL BUFFERS
    //
    private func loadAllBuffers() {
        
        for i in 0...(seq.players.count - 1) {
            loadBuffer(ofPlayer: i, withFile: i)
        }
    }
    
    //
    // MARK:- PRE SCHEDULE FIRST BUFFER
    //
    
    private func preScheduleFirstBuffer(forPlayer seletedPlayer: Int) {
        
        print(#function)
        
        printFrameLengths()
        
        seq.players[seletedPlayer].stop()
        if seq.displayedTracks[seletedPlayer].cells[0] == .ON {
            //
            // Schedule sound
            //
            seq.players[seletedPlayer].scheduleBuffer(seq.soundBuffers.normal[seletedPlayer], at: nil, options: [], completionHandler: nil)
        } else {
            //
            // Schedule silence
            //
            seq.players[seletedPlayer].scheduleBuffer(seq.silenceBuffers[seletedPlayer], at: nil, options: [], completionHandler: nil)
        }
        seq.players[seletedPlayer].prepare(withFrameCount: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: seletedPlayer)))
    }
    
    
    private func preScheduleFirstGuideBuffer() {
        
        print(#function)
        
        printFrameLengths()
        
        seq.guidePlayer.stop()
        
        //
        // Schedule silence
        //
        
        seq.guidePlayer.scheduleBuffer(seq.guideBuffer, at: nil, options: [], completionHandler: nil)
        
        seq.guidePlayer.prepare(withFrameCount: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: 0)))
    }
    
    func getSelectedTrackAndNumberOfCell(tag: Int) -> (Int, Int) {
        
        var selectedTrack = 0
        var numberOfCell: Int = 0
        switch tag {
        case 0...15:
            selectedTrack = 0
            numberOfCell = tag
        case 16...31:
            selectedTrack = 1
            numberOfCell = tag - 16
        case 32...47:
            selectedTrack = 2
            numberOfCell = tag - 32
        case 48...63:
            selectedTrack = 3
            numberOfCell = tag - 48
        default: selectedTrack = 99 // will not happen
        }
        print("You pressed a button ",numberOfCell," in row: ", selectedTrack)
        return (selectedTrack, numberOfCell)
    }
    
    //
    // MARK:- cellPressed
    //
    @IBAction func cellPressed(_ sender: UIButton) {
        
        //        print(#function)
        //
        //        var selectedTrack: Int
        //        var numberOfCell: Int
        //
        //        (selectedTrack, numberOfCell) = getSelectedTrackAndNumberOfCell(tag: sender.tag)
        //
        //        changeCell(selectedTrack, numberOfCell)
        
    }
    
    fileprivate func setCellTo(state: Cell, track: Int, cell: Int) {
        
        //print("swipeCellState: ", swipeCellState)
        switch swipeCellState {
        
        case .ON:
            trackButtonMatrix[track][cell].backgroundColor = K.Color.step
            seq.displayedTracks[track].cells[cell] = .ON
            
        case .OFF:
            trackButtonMatrix[track][cell].backgroundColor = .none
            seq.displayedTracks[track].cells[cell] = .OFF
            
        case .SOFT:
            trackButtonMatrix[track][cell].backgroundColor = K.Color.step_soft
            seq.displayedTracks[track].cells[cell] = .SOFT
            
        default:
            print("not gonna happen")
        }
        //print("swipeCellState: ", swipeCellState)
    }
    
    fileprivate func changeCell(_ track: Int, _ cell: Int) {
        
        //print(#function)
        print("1")
        if trackButtonMatrix[track][cell].backgroundColor == .none {
            print("2")
            
            //
            // Step is OFF: Set step to "ON" or "SOFT"
            //
            if !drawSoftNotes { // draw normal ON notes
                trackButtonMatrix[track][cell].backgroundColor = K.Color.step
                seq.displayedTracks[track].cells[cell] = .ON
                swipeCellState = .ON
            } else { // draw SOFT notes
                trackButtonMatrix[track][cell].backgroundColor = K.Color.step_soft
                seq.displayedTracks[track].cells[cell] = .SOFT
                swipeCellState = .SOFT
            }
            
            //        } else if trackButtonMatrix[track][cell].backgroundColor == K.Color.step {
            //
            //            //
            //            // Step is ON: Set step to "SOFT"
            //            //
            
            
        } else {
            print("3")
            
            //
            // Step is SOFT: Set Step to OFF
            //
            trackButtonMatrix[track][cell].backgroundColor = .none
            seq.displayedTracks[track].cells[cell] = .OFF
            swipeCellState = .OFF
            
        }
        print(drawSoftNotes)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        let touch = event?.allTouches?.first
        //let touchLocation = touch?.location(in: touch?.view)
        let touchLocation2 = touch?.location(in: self.view)
        //print("\(touchLocation?.x ?? 0.0) - \(touchLocation?.y ?? 0.0)")
        print("\(touchLocation2?.x ?? 0.0) - \(touchLocation2?.y ?? 0.0)")
        print("AA")
        
        //
        // Determine if inside a button
        //
        var button: Int? = nil
        if let touchX = touchLocation2?.x, let touchY = touchLocation2?.y {
            button = whichButtonHasBeenTouched(x: touchX, y: touchY)
        }
        //
        // If inside a button
        //
        if let b = button {
            print("BB")
            //print(#function, " Button No. ", b ," got touched!")
            // Which button? Which row?
            var selectedTrack: Int
            var numberOfCell: Int
            (selectedTrack, numberOfCell) = getSelectedTrackAndNumberOfCell(tag: b)
            
            changeCell(selectedTrack, numberOfCell)
        }
        print()
        print("--------------------------------------------------------------")
        print("01: ","isSwiping: ",isSwiping,"\tswipeStart: ",swipeStart ?? "nil","\tswipeStartMinY: ",swipeStartMinY ?? "nil","\tswipeStartMaxY: ",swipeStartMaxY ?? "nil","\tswipeCellState: ",swipeCellState ?? "nil")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        
        //
        // Are we inside a button?
        //
        let touch = event?.allTouches?.first
        let touchLocation = touch?.location(in: touch?.view)
        let touchLocation2 = touch?.location(in: self.view)
        //print("\(touchLocation?.x ?? 0.0) - \(touchLocation?.y ?? 0.0)")
        print("\(touchLocation2?.x ?? 0.0) - \(touchLocation2?.y ?? 0.0)")
        print("A")
        
        var button: Int? = nil
        if let touchX = touchLocation2?.x, let touchY = touchLocation2?.y {
            button = whichButtonHasBeenTouched(x: touchX, y: touchY)
        }
        if let b = button {
            print("B")
            
            //
            // If inside a button:
            //
            
            if !isSwiping {
                print("C")
                
                //
                // Swiping begins
                //
                isSwiping = true
                swipeStart = b
                swipeStartMinY = trackButtonMatrix.flatMap { $0 }[0...63][b].frame.minY
                swipeStartMaxY = trackButtonMatrix.flatMap { $0 }[0...63][b].frame.maxY
            } else {
                print("D")
                
                //
                // Check if already inside another button
                //
                if b != swipeStart {
                    print("E")
                    
                    // Which button? Which row?
                    var selectedTrack: Int
                    var numberOfCell: Int
                    (selectedTrack, numberOfCell) = getSelectedTrackAndNumberOfCell(tag: b)
                    //changeCell(selectedTrack, numberOfCell)
                    if let state = swipeCellState {
                        setCellTo(state: state, track: selectedTrack, cell: numberOfCell)
                    }
                    swipeStart = b
                }
            }
            
            //print("isSwiping: ", isSwiping, "swipeStart: ", swipeStart)
            
        } else {
            print("F")
            
            
            //
            // If outside:
            //
            
            //
            // Reset isSwiping to false if below or above current button row
            //
            if let touchY = touchLocation?.y, let minY = swipeStartMinY, let maxY = swipeStartMaxY {
                print("G")
                
                if !(minY...maxY).contains(touchY) {
                    print("H")
                    
                    isSwiping = false
                }
            }
            // print(#function, "isSwiping: ", isSwiping, "swipeStart: ", swipeStart)
            
        }
        
        print("02: ","isSwiping: ",isSwiping,"\tswipeStart: ",swipeStart ?? "nil","\tswipeStartMinY: ",swipeStartMinY ?? "nil","\tswipeStartMaxY: ",swipeStartMaxY ?? "nil","\tswipeCellState: ",swipeCellState ?? "nil")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        print(#function)
        isSwiping = false
        swipeStart = nil
        swipeStartMaxY = nil
        swipeStartMinY = nil
        swipeCellState = nil
        
        print("03: ","isSwiping: ",isSwiping,"\tswipeStart: ",swipeStart ?? "nil","\tswipeStartMinY: ",swipeStartMinY ?? "nil","\tswipeStartMaxY: ",swipeStartMaxY ?? "nil","\tswipeCellState: ",swipeCellState ?? "nil")
        print()
        
    }
    
    func whichButtonHasBeenTouched(x: CGFloat, y: CGFloat) -> Int? {
        print("whichIN: \(x) \(y)")
        var arrayOfFittingButtons: [Int?] = [Int]()
        var buttonNumber: Int? = nil
        for button in trackButtonMatrix.flatMap({ $0 })[0...63] {
            
            let myViewLocation = track0StackView.convert(button.frame, to: self.view)
            //print("myViewLocation: \(myViewLocation)")
            let loc = getConvertedPoint(button, baseView: self.view)
            //print("loc: \(loc)")
            let superMinX = loc.x
            let superMaxX = loc.x + myViewLocation.width
            let superMinY = loc.y
            let superMaxY = loc.y + myViewLocation.height
            
            
            let minX = button.frame.minX
            let maxX = button.frame.maxX
            let minY = button.frame.minY
            let maxY = button.frame.maxY
            
            // superview (horizontal stack view)
            let minX2 = button.superview?.frame.minX
            let maxX2 = button.superview?.frame.maxX
            let minY2 = button.superview?.frame.minY
            let maxY2 = button.superview?.frame.maxY
            
            // super - superview ("player" / horizontal stack view)
            let minX3 = button.superview?.superview?.frame.minX
            let maxX3 = button.superview?.superview?.frame.maxX
            let minY3 = button.superview?.superview?.frame.minY // these y coordinates give the real y of button inside view
            let maxY3 = button.superview?.superview?.frame.maxY // // these y coordinates give the real y of button inside view
            
            var isInX = false
            var isInY = false
            isInX = (superMinX...superMaxX).contains(x)
            isInY = (superMinY...superMaxY).contains(y)
            if isInX && isInY {
                buttonNumber = button.tag
                arrayOfFittingButtons.append(buttonNumber)
            }
            //            print("touchX / Y: ",x," / ",y, "Button: ", button.tag, "\tX: ",minX,"-", maxX, "\tY: ",minY,"-",maxY, isInX, isInY,"\t", minX2!, maxX2!, minY2!, maxY2!,"\t", minX3!, maxX3!, minY3!, maxY3!)
            
            //            print("touchX / Y: ",x," / ",y, "Button: ", button.tag, "\tX: ",minX,"-", maxX, "\tY: ",superMinY,"-",superMaxY, isInX, isInY)
        }
        if let b = buttonNumber {
            print("whichButtonHasBeenTouched: ", b)
        }
        // print("arrayOfFittingButtons: \(arrayOfFittingButtons)")
        return buttonNumber
    }
    
    //    @IBAction func enteringButtonWhileDragging(_ sender: UIButton) {
    //
    //        print()
    //        print(#function)
    //
    //        // Which button? Which row?
    //        var selectedTrack: Int
    //        var numberOfCell: Int
    //        (selectedTrack, numberOfCell) = getSelectedTrackAndNumberOfCell(tag: sender.tag)
    //
    //
    //    }
    
    //
    // MARK:- muteButton action
    //
    @IBAction func muteButtonPressed(_ sender: UIButton) {
        
        seq.displayedTracks[sender.tag].muted = !seq.displayedTracks[sender.tag].muted
        
        if seq.displayedTracks[sender.tag].muted {
            //
            // Mute row / player
            //
            seq.players[sender.tag].volume = 0
            muteButtons[sender.tag].backgroundColor = .none
            muteButtons[sender.tag].tintColor = K.Color.blue_brightest
            
            let buttonRowToBeMuted = trackButtonMatrix[sender.tag]
            for button in buttonRowToBeMuted {
                button.alpha = 0.3
            }
            
        } else {
            //
            // Un-mute row / player
            //
            seq.players[sender.tag].volume = Float(seq.displayedTracks[sender.tag].volume)
            muteButtons[sender.tag].backgroundColor = K.Color.muteButtonColor
            muteButtons[sender.tag].tintColor = K.Color.blue_brightest
            
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
            
            if seq.displayedTracks[0].cells[index] == .ON {
                
                button.backgroundColor = K.Color.step
                
            } else if seq.displayedTracks[0].cells[index] == .SOFT {
                
                button.backgroundColor = K.Color.step_soft
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track1Buttons.enumerated() {
            
            if seq.displayedTracks[1].cells[index] == .ON {
                
                button.backgroundColor = K.Color.step
                
            } else if seq.displayedTracks[1].cells[index] == .SOFT {
                
                button.backgroundColor = K.Color.step_soft
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track2Buttons.enumerated() {
            
            if seq.displayedTracks[2].cells[index] == .ON {
                
                button.backgroundColor = K.Color.step
                
            } else if seq.displayedTracks[2].cells[index] == .SOFT {
                
                button.backgroundColor = K.Color.step_soft
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        for (index, button) in track3Buttons.enumerated() {
            
            if seq.displayedTracks[3].cells[index] == .ON {
                
                button.backgroundColor = K.Color.step
                
            } else if seq.displayedTracks[3].cells[index] == .SOFT {
                
                button.backgroundColor = K.Color.step_soft
                
            } else {
                
                button.backgroundColor = .none
            }
        }
        
        //
        // Set Vol / Rev / Delay sliders to values in tracks Array
        //
        for (index, slider) in trackVolumeSliders.enumerated() {
            slider.value = Float(seq.displayedTracks[index].volume)
        }
        for (index, slider) in trackReverbSliders.enumerated() {
            slider.value = Float(seq.displayedTracks[index].reverbMix)
        }
        for (index, slider) in trackDelaySliders.enumerated() {
            slider.value = Float(seq.displayedTracks[index].delayMix)
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
//            trackCellsView.isHidden = false
//            trackControlsLabelsStackView.isHidden = false
//
//            for slider in trackVolumeSliders {
//                slider.isHidden = false
//            }
//            for slider in trackReverbSliders {
//                slider.isHidden = false
//            }
//            for slider in trackDelaySliders {
//                slider.isHidden = false
//            }
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
//            trackCellsView.isHidden = true
//            trackControlsLabelsStackView.isHidden = true
//
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
        seq.displayedTracks[selectedPlayer].numberOfCellsActive = Int(newNumberOfCells)
        
        //
        // Hide alle cells
        //
        for button in trackButtonMatrix[selectedPlayer] {
            button.isHidden = true
        }
        
        //
        // Show only active cells
        //
        for i in 0...(seq.displayedTracks[selectedPlayer].numberOfCellsActive - 1) {
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
        seq.displayedTracks[sender.tag].volume = Double(sender.value)
        
        //
        // Only change player volume if not muted
        //
        if !seq.displayedTracks[sender.tag].muted {
            seq.players[sender.tag].volume = sender.value}
    }
    
    //
    // MARK:- trackReverbChanged()
    //
    @IBAction func trackReverbChanged(_ sender: UISlider) {
        print(#function)
        print(sender.tag, sender.value)
        seq.displayedTracks[sender.tag].reverbMix = Double(sender.value * 100)
        seq.reverbs[sender.tag].wetDryMix = sender.value * 100
    }
    
    //
    // MARK:- trackDelayChanged()
    //
    @IBAction func trackDelayChanged(_ sender: UISlider) {
        print(#function)
        print(sender.tag, sender.value)
        seq.displayedTracks[sender.tag].delayMix = Double(sender.value * 100)
        seq.delays[sender.tag].wetDryMix = sender.value * 100
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
//        bpmStepper.value = seq.tempo!.bpm
        
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
        print("Delay old: ", seq.delays[0].delayTime)
        let newDelayTime = 60.0 / seq.tempo!.bpm * 0.75
        for delay in seq.delays {
            delay.delayTime = newDelayTime
        }
        print("Delay new: ", seq.delays[0].delayTime)
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
        
        print(self.seq.soundBuffers.normal[0].frameLength, self.seq.silenceBuffers[0].frameLength, "  ",
              self.seq.soundBuffers.normal[1].frameLength, self.seq.silenceBuffers[1].frameLength, "  ",
              self.seq.soundBuffers.normal[2].frameLength, self.seq.silenceBuffers[2].frameLength, "  ",
              self.seq.soundBuffers.normal[3].frameLength, self.seq.silenceBuffers[3].frameLength, "  ",
              self.seq.guideBuffer.frameLength
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
