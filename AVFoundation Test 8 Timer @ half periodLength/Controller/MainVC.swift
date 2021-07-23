// using timer to schedule buffers
// https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer


import UIKit
import AVFoundation
import RealmSwift

fileprivate let DEBUG = false
fileprivate let DEBUG1 = false
fileprivate let DEBUG2 = false
fileprivate let DEBUG3 = false


class MainVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let realm = try! Realm()
    
    var seq = Sequencer()
    var settingsVC = SettingsVC()
    
    var controlsHidden = true
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
    
    private var timerEventCounterArray = Array(repeating: 0, count: K.Sequencer.numberOfTracks)
    private var currentStepIndexArray = Array(repeating: 0, count: K.Sequencer.numberOfTracks)
    private var timers = Array(repeating: Timer(), count: K.Sequencer.numberOfTracks)
    
    private var timerEventCounterGuide: Int = 1
    private var currentStepGuide: Int = 1
    
    private enum State {case run; case stop}
    private var state: State = .stop
    
    private var timerGuide: Timer! = nil
    private var timer_x: Timer! = nil
    
    // MARK:-  OUTLETS
    
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
    // player4 steps
    //
    @IBOutlet weak var track4StackView: UIStackView!
    var track4Buttons: [UIButton] = []
    
    
    @IBOutlet weak var XXX: UIStackView!
    
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
    @IBOutlet weak var settingsButton0: UIButton!
    @IBOutlet weak var settingsButton1: UIButton!
    @IBOutlet weak var settingsButton2: UIButton!
    @IBOutlet weak var settingsButton3: UIButton!
    var trackSettingsButtons = [UIButton]()
    
    //
    // Main Controls at bottom (Play, Tap, Parts...)
    //
    //    @IBOutlet weak var settingsButton: UIButton!
    
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
        
        
        
        
        // loadGuideBuffer()
        
        
        //preScheduleFirstGuideBuffer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setupUI() // one time setup
        
        
        //loadSnapShot(fileName: "default")
        loadSnapshot("default")
        
        updateUI()
        
        for i in 0...(K.Sequencer.numberOfTracks - 1){
            if let file = seq.fileNames.normal.firstIndex(of: seq.selectedSounds[i]) {
                loadBuffer(ofPlayer: i, withFile: file)
            }
        }
        
        showOrHideControls()
        
        //
        // MARK: - Title Navigation bar
        //
        title = "Step Drummer"
        
        
        print("settingsButton0.frame.size.width: \(settingsButton0.frame.size.width)")
        print("settingsButton0.frame.size.height: \(settingsButton0.frame.size.height)")
        print("settingsButton0.imageView?.frame.size.width: \(String(describing: settingsButton0.imageView?.frame.size.width))")
        print("settingsButton0.imageView?.frame.size.height: \(String(describing: settingsButton0.imageView?.frame.size.height))")
        
        print("mute0Button.frame.size.width: \(mute0Button.frame.size.width)")
        print("mute0Button.frame.size.height: \(mute0Button.frame.size.height)")
        print("mute0Button.imageView?.frame.size.width: \(String(describing: mute0Button.imageView?.frame.size.width))")
        print("mute0Button.imageView?.frame.size.height: \(String(describing: mute0Button.imageView?.frame.size.height))")
        
        seq.changeTempoAndPrescheduleBuffers(bpm: 120)

        
    }
    
    //
    // MARK:- Load buffers (with parameter) -- NEW: Creating up to 16 different length buffers (depending on file length)
    //
    func loadBuffer(ofPlayer playerIndex: Int, withFile fileIndex: Int) {
        
        //
        // MARK: Loading buffer. Buffers are attached to a player. Files to read into buffer can be changed
        //
        
        print()
        print("Loading Buffer of Player \(playerIndex) with file # \(fileIndex):")
        let path_normal = Bundle.main.path(forResource: seq.fileNames.normal[fileIndex], ofType: nil)!
        let path_soft = Bundle.main.path(forResource: seq.fileNames.soft[fileIndex], ofType: nil)!
        //let path = Bundle.main.path(forResource: fileNames[file_to_load], ofType: nil)!
        
        let url_normal = URL(fileURLWithPath: path_normal)
        let url_soft = URL(fileURLWithPath: path_soft)
        
        do {
            seq.files.normal[fileIndex] = try AVAudioFile(forReading: url_normal)
            seq.files.soft[fileIndex] = try AVAudioFile(forReading: url_soft)
            
            //
            // Determine length of soundfile in whole cells
            //
            let lengthOfFileInSamples = seq.files.normal[fileIndex].length
            print("lengthOfFileInSamples: \(lengthOfFileInSamples)")
            let lengthOf16thNoteInSamples = seq.durationOf16thNoteInSamples(forTrack: playerIndex)
            print("lengthOf16thNote: \(lengthOf16thNoteInSamples)")
            var numberOf16thCellsNeededToPlayWholeFile: Int = Int(ceil(Double(lengthOfFileInSamples) / lengthOf16thNoteInSamples))
            print("numberOf16thCellsNeededToPlayWholeFile: \(numberOf16thCellsNeededToPlayWholeFile)")
            if numberOf16thCellsNeededToPlayWholeFile > 16 {
                print("too large, cutting to 1 bar!")
                numberOf16thCellsNeededToPlayWholeFile = 16
            }
            print("numberOf16thCellsNeededToPlayWholeFile: \(numberOf16thCellsNeededToPlayWholeFile)")
            
            
            seq.soundBuffers.lengthOfBufferInWholeCells[playerIndex] = numberOf16thCellsNeededToPlayWholeFile
            
            //
            // Create snippets of 1 cell, 2 cells, 3 cells.... until numberOf16thCellsNeededToPlayWholeFile
            //
            for i in 0..<numberOf16thCellsNeededToPlayWholeFile {
                //
                let cellsToFill =  i + 1
                let numberOfCellsToFillInSamples = Double(cellsToFill) * lengthOf16thNoteInSamples
                
                print("Filling \(cellsToFill) cells (\(numberOfCellsToFillInSamples) samples.)")
                
                if let normal_buffer = AVAudioPCMBuffer(pcmFormat: seq.files.normal[fileIndex].processingFormat, frameCapacity: AVAudioFrameCount(numberOfCellsToFillInSamples)) {
                    
                    seq.soundBuffers.normal[playerIndex][i] = normal_buffer
                    
                } else {
                    fatalError("Could not create normal buffer")
                }
                
                if let soft_buffer = AVAudioPCMBuffer(pcmFormat: seq.files.soft[fileIndex].processingFormat, frameCapacity: AVAudioFrameCount(numberOfCellsToFillInSamples)) {
                    
                    seq.soundBuffers.soft[playerIndex][i] = soft_buffer
                } else {
                    fatalError("Could not create soft buffer")
                }
                //
                // Reset read position to beginning and read into buffer
                //
                seq.files.normal[fileIndex].framePosition = 0
                try seq.files.normal[fileIndex].read(into: seq.soundBuffers.normal[playerIndex][i])
                seq.files.soft[fileIndex].framePosition = 0
                try seq.files.soft[fileIndex].read(into: seq.soundBuffers.soft[playerIndex][i])
                
                seq.soundBuffers.normal[playerIndex][i].frameLength = AVAudioFrameCount(numberOfCellsToFillInSamples)
                seq.soundBuffers.soft[playerIndex][i].frameLength = AVAudioFrameCount(numberOfCellsToFillInSamples)
                
            }
        } catch { print("Error loading buffer \(playerIndex) \(error)") }
        
        
        //
        // MARK: Loading silence buffer
        //
        let pathSilence = Bundle.main.path(forResource: seq.fileNameSilence, ofType: nil)!
        let urlSilence = URL(fileURLWithPath: pathSilence)
        do {
            seq.fileSilence = try AVAudioFile(forReading: urlSilence)
            seq.silenceBuffers[playerIndex] = AVAudioPCMBuffer(
                pcmFormat: seq.fileSilence.processingFormat,
                frameCapacity: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: playerIndex)))!
            try seq.fileSilence.read(into: seq.silenceBuffers[playerIndex])
            seq.silenceBuffers[playerIndex].frameLength = AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: playerIndex))
        } catch {
            print("Error loading silence buffer0 \(playerIndex) \(error)")
        }
        
        
    }
    
    //
    // MARK:- LOAD GUIDE BUFFER
    //
    func loadGuideBuffer() {
        
        //
        // MARK: Loading buffer - attached to player0 - TODO: file0 / file1 / ... will be made variable later!
        //
        //let path = Bundle.main.path(forResource: seq.fileNameSilence, ofType: nil)!
        
        //let url = URL(fileURLWithPath: path)
        
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
        
        print()
        print ("currentStepIndexArray: \(currentStepIndexArray)")
        print ("timerEventCounterArray: \(timerEventCounterArray )")
        print ("seq.cellsToWaitBeforeReschedulingArray: \(seq.cellsToWaitBeforeReschedulingArray )")
        print()
        
        sender.isSelected = !sender.isSelected
        
        if drawSoftNotes {
            //
            // switch soft note mode OFF
            //
            drawSoftNotes = false
            //chainButton.setImage(UIImage(systemName: K.Image.playImage), for: .normal)
            softModeButton.backgroundColor = K.Color.orange
        } else {
            //
            // switch soft note mode  ON
            //
            drawSoftNotes = true
            //chainButton.setImage(UIImage(systemName: K.Image.pauseImage), for: .normal)
            softModeButton.backgroundColor = K.Color.orange_brighter
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
            deleteButton.backgroundColor = K.Color.orange_brighter
            deleteButton.flashPermanently()
            
            //
            // Let inactive part buttons flash
            
            //
            partSegmentedControl.flashPermanently()
        }
        
    }
    
    func endDeleteMode() {
        
        deleteMode = false
        deleteButton.backgroundColor = K.Color.orange
        deleteButton.layer.removeAllAnimations()
        partSegmentedControl.layer.removeAllAnimations()
        if let sourcePart = deleteModeSource {
            changeToPart(sourcePart)
        }
    }
    
    func endCopyMode() {
        
        copyMode = false
        copyButton.backgroundColor = K.Color.orange
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
            copyButton.backgroundColor = K.Color.orange_brighter
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
            chainButton.backgroundColor = K.Color.orange
        } else {                // color chain mode ON
            chainButton.backgroundColor = K.Color.orange_brighter
        }
        print(next)
        print(next.description)
        chainButton.setTitle(next.description, for: .normal)
        
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
            
            seq.changeTempoAndPrescheduleBuffers(bpm: newTempo)
            //            seq.tempo?.bpm = newTempo
            //            seq.preScheduleFirstBuffer(forPlayer: 0)
            //            seq.preScheduleFirstBuffer(forPlayer: 1)
            //            seq.preScheduleFirstBuffer(forPlayer: 2)
            //            seq.preScheduleFirstBuffer(forPlayer: 3)
            preScheduleFirstGuideBuffer()
            
            updateUIAfterTempoChange(to: newTempo, restart: true)
            saveSnapshot(name: "default")
            
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
                let action = UIAlertAction(title: "OK", style: .default) /*{ [unowned copyCompleteAlert] _ in }*/
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
            let deleteAction = UIAlertAction(title: "OK", style: .default) /*{ [unowned deleteCompleteAlert] _ in }*/
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
            playPauseButton.backgroundColor = K.Color.orange
            
            //for label in self.beatLabels {label.text = ""}
            
            for timerIndex in 0...(K.Sequencer.numberOfTracks-1) {
                timers[timerIndex].invalidate()
                timerEventCounterArray[timerIndex] = 0
                currentStepIndexArray[timerIndex] = 0
                seq.cellsToWaitBeforeReschedulingArray[timerIndex] = 0
            }
            
            timer_x.invalidate()
            
            //            preScheduleFirstBuffer_OLD()
            if let tempo = seq.tempo {
                seq.changeTempoAndPrescheduleBuffers(bpm: tempo.bpm)
            }
            
        //    preScheduleFirstGuideBuffer()
            
        } else {
            
            //
            // Go!
            //
//            for timerIndex in 0...(K.Sequencer.numberOfTracks-1) {
//                timers[timerIndex].invalidate()
//                timerEventCounterArray[timerIndex] = 0
//                currentStepIndexArray[timerIndex] = 0
//                seq.cellsToWaitBeforeReschedulingArray[timerIndex] = 0
//            }
            
            state = .run
            playPauseButton.setImage(UIImage(systemName: K.Image.pauseImage), for: .normal)
            playPauseButton.backgroundColor = K.Color.orange_brighter
            
            startPlayers()
            startAllTimers()
        }
    }
    
    
    
    fileprivate func scheduleNextBuffer(timerIndex: Int, nextStepIndex: Int, bufferScheduled: inout String, normalVolume: Bool = true) {
        
        if self.seq.cellsToWaitBeforeReschedulingArray[timerIndex] == 0 {
            
            //
            // Compute distance to next .ON
            //
            let lengthToSchedule = seq.computeLengthToSchedule(nextStepIndex: nextStepIndex, timerIndex: timerIndex)
            print("SCHED NEXT\n")
            //
            // scheduleBuffer
            //
            let indexToSchedule = lengthToSchedule - 1
            if normalVolume {
                
                //
                // Schedule .ON sound
                //
                self.seq.players[timerIndex].scheduleBuffer(self.seq.soundBuffers.normal[timerIndex][indexToSchedule], at: nil, options: [], completionHandler: nil)
                bufferScheduled = ".ON[\(timerIndex)][\(indexToSchedule)] "
            } else {
                
                //
                // Schedule .SOFT sound
                //
                self.seq.players[timerIndex].scheduleBuffer(self.seq.soundBuffers.soft[timerIndex][indexToSchedule], at: nil, options: [], completionHandler: nil)
                bufferScheduled = ".SOFT [\(timerIndex)][\(indexToSchedule)] "
            }
            
        } else {
            self.seq.cellsToWaitBeforeReschedulingArray[timerIndex] -= 1
        }
    }
    
    //
    // START ALL TIMERS
    //
    fileprivate func startAllTimers() {
        
        
        if DEBUG {
            print("# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  ")
            //            print(seq.soundBuffers.normal[0].frameLength, seq.soundBuffers.normal[1].frameLength, seq.soundBuffers.normal[2].frameLength, seq.soundBuffers.normal[3].frameLength)
        }
        
        timer_x = Timer.scheduledTimer(withTimeInterval: 60.0/(self.seq.tempo!.bpm * 4.0 * 2.0), repeats: true) {
            [unowned self] timer in
            
            // print("-----------------------------------")
            for player in self.seq.players {
                guard let lRTime = player.lastRenderTime else {
                    print("nodeTime Error")
                    return
                }
                guard let playerTime = player.playerTime(forNodeTime: lRTime) else {
                    print("playerTime Error")
                    return
                }
                //let startSampleTime = lRTime.sampleTime
                //let startTime = AVAudioTime(sampleTime: startSampleTime, atRate: player.outputFormat(forBus: 0).sampleRate)
                // let timeInSamples = playerTime.sampleTime
                // let timeInSamplesAsDouble = Double(playerTime.sampleTime)
                // print("lRTime: \(lRTime) playerTime: \(playerTime) \ntimeInSamples: \(timeInSamples) timeInSamplesAsDouble \(timeInSamplesAsDouble)")
                //   print("current: \(player.current)")
            }
            //  print("-----------------------------------")
        }
        
        
        
        for timerIndex in 0...(K.Sequencer.numberOfTracks - 1) {
            //
            //  MARK:- NEW Timer for player0
            //
            let timerIntervalInSeconds = self.seq.durationOf16thNoteInSamples(forTrack: timerIndex) / (2 * K.Sequencer.sampleRate) // 1/2 of 16th note in seconds
            
            timers[timerIndex] = Timer.scheduledTimer(withTimeInterval: timerIntervalInSeconds, repeats: true) { timer in
                
                //
                // Compute & dump debug values
                //
                // Values at begin of timer event
                var currentTime = round(self.seq.players[timerIndex].currentTimeInSeconds, toDigits: 3)
                
                if DEBUG {
                    print("player \(timerIndex) timerEvent #\(self.timerEventCounterArray[timerIndex]) at \(self.seq.tempo!.bpm) BPM")
                    print("Entering \ttimerEvent: \(self.timerEventCounterArray[timerIndex]) \tstep: \(self.currentStepIndexArray[timerIndex]) \tcurrTime: \(currentTime)")
                    print("seq.cellsToWaitBeforeRescheduling: \(self.seq.cellsToWaitBeforeReschedulingArray[timerIndex])")
                }
                
                //
                // Schedule next buffer on even events / increase beat counter on odd events
                //
                var bufferScheduled: String = "" // only needed for debugging / console output
                
                if self.timerEventCounterArray[timerIndex] % 2 == 0 || self.timerEventCounterArray[timerIndex] == 0 {
                    
                    //
                    // EVEN event (0, 2, 4, 6, 8, ...): schedule next buffer
                    //
                    //print("EVEN 2,4,6,8...")
                    //                var nextStep = self.currentStep0
                    //                print ("nextStep: \(nextStep)")
                    //                if nextStep == (self.seq.displayedTracks[0].numberOfCellsActive - 1) {
                    //                    nextStep = 0
                    //                }
                    //                if nextStep == 0 {
                    //                    print("*** ", self.seq.distortions[0].wetDryMix, self.seq.distortions[0].preGain, self.seq.distortions[0].self)
                    //                }
                    
                    //
                    // Look at next cell
                    //
                    var nextStepIndex = self.currentStepIndexArray[timerIndex] + 1
                    
                    //
                    // If overflow, nextstep is equal to first cell
                    //
                    if nextStepIndex == (self.seq.displayedTracks[timerIndex].numberOfCellsActive) {
                        nextStepIndex = 0
                    }
                    
                    
                    //
                    // Get next cell
                    //
                    // If we're at last step of a pattern && chain mode is on, look into next pattern according to selected chain mode
                    //
                    let nextCell: Cell
                    
                    if nextStepIndex != 0 {
                        //
                        // We're not at the last step: nextCell is taken of activePart
                        //
                        nextCell = self.seq.displayedTracks[timerIndex].cells[nextStepIndex]
                    } else {
                        //
                        // We're at the last step...
                        //
                        if self.seq.chainMode == .OFF {
                            //
                            // Chain mode is off: Take first cell of activePart as nextCell
                            //
                            nextCell = self.seq.displayedTracks[timerIndex].cells[nextStepIndex]
                            print("++++++ chainMode: OFF. Next cell will be of this Part: \(nextCell)")
                        } else {
                            //
                            // Chain mode is on: Take first cell of chained next Part as nextCell
                            //
                            if self.seq.chainMode == .AB {
                                if self.seq.activePart == .A {
                                    //
                                    // We're in Part A, so look into Part B
                                    //
                                    nextCell = (self.seq.parts[.B]?.patterns[timerIndex].cells[0])!
                                    print("++++++ chainMode: ON.Next cell will be of Part B: \(nextCell)")
                                } else {
                                    //
                                    // We're in Part B, so look into Part A
                                    //
                                    nextCell = (self.seq.parts[.A]?.patterns[timerIndex].cells[0])!
                                    print("++++++ chainMode: ON. Next cell will be of Part A: \(nextCell)")
                                }
                                
                            } else if self.seq.chainMode == .CD {
                                if self.seq.activePart == .C {
                                    //
                                    // We're in Part C, so look into Part D
                                    //
                                    nextCell = (self.seq.parts[.D]?.patterns[timerIndex].cells[0])!
                                    print("++++++ chainMode: ON.Next cell will be of Part B: \(nextCell)")
                                } else {
                                    //
                                    // We're in Part D, so look into Part C
                                    //
                                    nextCell = (self.seq.parts[.C]?.patterns[timerIndex].cells[0])!
                                    print("++++++ chainMode: ON. Next cell will be of Part A: \(nextCell)")
                                }
                                
                            } else if self.seq.chainMode == .ABCD {
                                if self.seq.activePart == .A {
                                    //
                                    // We're in Part A, so look into Part B
                                    //
                                    nextCell = (self.seq.parts[.B]?.patterns[timerIndex].cells[0])!
                                    print("++++++ chainMode: \(self.seq.chainMode) Next cell will be of Part B: \(nextCell)")
                                } else if self.seq.activePart == .B {
                                    //
                                    // We're in Part B, so look into Part C
                                    //
                                    nextCell = (self.seq.parts[.C]?.patterns[timerIndex].cells[0])!
                                    print("++++++ chainMode: \(self.seq.chainMode) Next cell will be of Part C: \(nextCell)")
                                } else if self.seq.activePart == .C {
                                    //
                                    // We're in Part C, so look into Part D
                                    //
                                    nextCell = (self.seq.parts[.D]?.patterns[timerIndex].cells[0])!
                                    print("++++++ chainMode: \(self.seq.chainMode) Next cell will be of Part D: \(nextCell)")
                                } else {
                                    //
                                    // We're in Part D, so look into Part A
                                    //
                                    nextCell = (self.seq.parts[.A]?.patterns[timerIndex].cells[0])!
                                    print("++++++ chainMode: \(self.seq.chainMode) Next cell will be of Part A: \(nextCell)")
                                }
                                
                                
                                
                            } else {
                                //
                                // DEFAULT CASE: FIX ME! TAKIN' part B as default. Should never be the case anyway!
                                //
                                nextCell = (self.seq.parts[.B]?.patterns[timerIndex].cells[0])!
                                print("++++++ chainMode: UNCLEAR. SHOULD NOT HAPPEN! Next cell will be of Part B: \(nextCell)")
                            }
                            print("chain mode: ON")
                        }
                    }
                        
                    if nextCell == .ON {
                        
                        //
                        // nextCell == .ON
                        //
                        self.scheduleNextBuffer(timerIndex: timerIndex, nextStepIndex: nextStepIndex, bufferScheduled: &bufferScheduled, normalVolume: true)
                        
                    } else if nextCell == .SOFT {
                        
                        //
                        // nextCell == .SOFT
                        //
                        self.scheduleNextBuffer(timerIndex: timerIndex, nextStepIndex: nextStepIndex, bufferScheduled: &bufferScheduled, normalVolume: false)
                        
                    } else {
                        
                        //
                        // nextCell == .OFF
                        //
                        if self.seq.cellsToWaitBeforeReschedulingArray[timerIndex] == 0 {
                            self.seq.players[timerIndex].scheduleBuffer(self.seq.silenceBuffers[timerIndex], at: nil, options: [], completionHandler: nil)
                            bufferScheduled = "buffer\(timerIndex)Silence"
                        } else {
                            self.seq.cellsToWaitBeforeReschedulingArray[timerIndex] -= 1
                        }
                    }
                    
                    //
                    // Increase timerEventCounter, two events per beat.
                    //
                    //print("** ** ** EVEN: Increasing timerEventCounter0 now!")
                    self.timerEventCounterArray[timerIndex] += 1
                    //print ("** ** ** timerEventCounter0: \(self.timerEventCounter0)")
                    
                    
                    if self.timerEventCounterArray[timerIndex] > ((self.seq.displayedTracks[timerIndex].numberOfCellsActive * 2) - 1 ) {
                        //print("resetting timerEventCounter0 to 0!")
                        self.timerEventCounterArray[timerIndex] = 0
                    }
                    
                } else {
                    //
                    // ODD event (1, 3, 5, 7, 9...): increase stepCounter
                    //
                    //print("ODD 1,3,5,7...")
                    
                    //
                    // Increase currentStep
                    //
                    self.currentStepIndexArray[timerIndex] += 1
                    
                    
                    //
                    // Check if last step (default: 15) reached
                    //
                    if self.currentStepIndexArray[timerIndex] > self.seq.displayedTracks[timerIndex].numberOfCellsActive - 1 {
                        self.currentStepIndexArray[timerIndex] = 0
                        
                        if timerIndex == 0 {  // (only check once, for timer 0!)
                            if self.seq.chainMode == .ABCD {
                                var nextPart = self.seq.activePart.rawValue + 1
                                if nextPart == 4 { nextPart = 0 }
                                self.changeToPart(PartNames(rawValue: nextPart)!)
                            }
                            if self.seq.chainMode == .AB {
                                print("++++++++ AB Chain Mode +++++++++ ")
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
                        }
                    }
                    
                    //
                    // Increase timerEventCounter, two events per beat.
                    //
                    //print("** ** ** ODD: Increasing timerEventCounter0 now!")
                    self.timerEventCounterArray[timerIndex] += 1
                    //print ("** ** ** timerEventCounter0: \(self.timerEventCounter0)")
                    
                    //
                    // Check timerEventCounter overflow & reset to 0 if neccessary
                    //
                    if self.timerEventCounterArray[timerIndex] > ((self.seq.displayedTracks[timerIndex].numberOfCellsActive * 2) - 1 ) {
                        //print("resetting timerEventCounter0 to 0!")
                        self.timerEventCounterArray[timerIndex] = 0
                    }
                }
                
                //
                // Display current beat & increase currentBeat (1...4) at 2nd, 4th, 6th & 8th timerEvent
                //
                DispatchQueue.main.async {
                    self.trackButtonMatrix[timerIndex][self.currentStepIndexArray[timerIndex]].flash()
                    //self.track0Buttons[self.currentStepIndexArray[timerIndex]].flash()
                }
                
                //
                // Values at end of timer event
                //
                if DEBUG {
                    currentTime = round(self.seq.players[timerIndex].currentTimeInSeconds, toDigits: 3)
                    print("Exiting \ttimerEvent: \(self.timerEventCounterArray[timerIndex]) \tstep: \(self.currentStepIndexArray[timerIndex]) \tcurrTime: \(currentTime) \t\(bufferScheduled)")
                    print("cellsToWaitBeforeRescheduling0: \(self.seq.cellsToWaitBeforeReschedulingArray[timerIndex])")
                    print()
                }
            }
            RunLoop.current.add(timers[timerIndex], forMode: .common)
        }
    }
    
    //
    // MARK:- START PLAYERS
    //
    private func startPlayers() {
        
        let kStartDelayTime = 0.0
        let now = Double(seq.players[0].lastRenderTime?.sampleTime ?? 0) // reference time to sync all players to
        let startTime = AVAudioTime(sampleTime: AVAudioFramePosition((now + kStartDelayTime * K.Sequencer.sampleRate)), atRate: K.Sequencer.sampleRate)
        
        seq.players[0].play(at: startTime)
        seq.players[1].play(at: startTime)
        seq.players[2].play(at: startTime)
        seq.players[3].play(at: startTime)
    }
    
    //
    // MARK:- LOAD ALL BUFFERS
    //
    private func loadAllBuffers() {
        
        //        for i in 0...(seq.players.count - 1) {
        //            loadBuffer(ofPlayer: i, withFile: i)
        //        }
        for i in 0...(K.Sequencer.numberOfTracks - 1){
            if let file = seq.fileNames.normal.firstIndex(of: seq.selectedSounds[i]) {
                loadBuffer(ofPlayer: i, withFile: file)
            }
        }
    }
    
    private func preScheduleFirstGuideBuffer() {
        
        print(#function)
        
        //  printFrameLengths()
        
        seq.guidePlayer.stop()
        
        //
        // Schedule silence
        //
        
        //        if seq.engine.isRunning && {
        //            seq.guidePlayer.scheduleBuffer(seq.guideBuffer, at: nil, options: [], completionHandler: nil)
        //
        //            seq.guidePlayer.prepare(withFrameCount: AVAudioFrameCount(seq.durationOf16thNoteInSamples(forTrack: 0)))
        //        }
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
        seq.saveToPart(partName: seq.activePart)
        //        saveSnapShot(fileName: "default")
        saveSnapshot(name: "default")
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
        seq.saveToPart(partName: seq.activePart)
        //        saveSnapShot(fileName: "default")
        saveSnapshot(name: "default")
        
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
        //        print()
        //        print("--------------------------------------------------------------")
        //        print("01: ","isSwiping: ",isSwiping,"\tswipeStart: ",swipeStart ?? "nil","\tswipeStartMinY: ",swipeStartMinY ?? "nil","\tswipeStartMaxY: ",swipeStartMaxY ?? "nil","\tswipeCellState: ",swipeCellState ?? "nil")
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
            
            
            /* let minX = button.frame.minX
             let maxX = button.frame.maxX
             let minY = button.frame.minY
             let maxY = button.frame.maxY
             */
            // superview (horizontal stack view)
            /* let minX2 = button.superview?.frame.minX
             let maxX2 = button.superview?.frame.maxX
             let minY2 = button.superview?.frame.minY
             let maxY2 = button.superview?.frame.maxY
             */
            // super - superview ("player" / horizontal stack view)
            /* let minX3 = button.superview?.superview?.frame.minX
             let maxX3 = button.superview?.superview?.frame.maxX
             */
            /*     let minY3 = button.superview?.superview?.frame.minY */ // these y coordinates give the real y of button inside view
            /*      let maxY3 = button.superview?.superview?.frame.maxY */ // // these y coordinates give the real y of button inside view
            
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
            //            muteButtons[sender.tag].backgroundColor = .none
            muteButtons[sender.tag].tintColor = K.Color.blue_brighter
            
            let buttonRowToBeMuted = trackButtonMatrix[sender.tag]
            for button in buttonRowToBeMuted {
                button.alpha = 0.3
            }
            
        } else {
            //
            // Un-mute row / player
            //
            seq.players[sender.tag].volume = Float(seq.volumes[sender.tag])
            //            muteButtons[sender.tag].backgroundColor = K.Color.muteButtonColor
            muteButtons[sender.tag].tintColor = K.Color.white
            
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
        
        let activePart = seq.activePart
        for trackIndex in 0...(K.Sequencer.numberOfTracks - 1) {
            if let part = seq.parts[activePart] {
                seq.displayedTracks[trackIndex].cells = (part.patterns[trackIndex].cells)
            }
        }
        
        //        seq.displayedTracks[0].cells = (seq.parts[.A]?.patterns[0].cells)!
        //        seq.displayedTracks[1].cells = (seq.parts[.A]?.patterns[1].cells)!
        //        seq.displayedTracks[2].cells = (seq.parts[.A]?.patterns[2].cells)!
        //        seq.displayedTracks[3].cells = (seq.parts[.A]?.patterns[3].cells)!
        
        
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
        //        for (index, slider) in trackVolumeSliders.enumerated() {
        //            slider.value = Float(seq.displayedTracks[index].volume)
        //        }
        //        for (index, slider) in trackReverbSliders.enumerated() {
        //            slider.value = Float(seq.displayedTracks[index].reverbMix)
        //        }
        //        for (index, slider) in trackDelaySliders.enumerated() {
        //            slider.value = Float(seq.displayedTracks[index].delayMix)
        //        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueNames = ["goToTrackSettingsVC0", "goToTrackSettingsVC1", "goToTrackSettingsVC2", "goToTrackSettingsVC3"]
        
        for (index, segueName) in segueNames.enumerated() {
            if segue.identifier == segueName {
                let navVC = segue.destination
                let  trackSettingsVC = navVC.children.first as! TrackSettingsVC
                //                let trackSettingsVC = segue.destination as! TrackSettingsVC
                
                trackSettingsVC.popoverPresentationController?.delegate = self
                //trackSettingsVC.popoverPresentationController?.passthroughViews = [self.view]
                
                trackSettingsVC.delegate = self
                
                trackSettingsVC.currentPlayer = (sender as! UIButton).tag
                
                trackSettingsVC.selectedSound = seq.selectedSounds[index]
                trackSettingsVC.fileNames = seq.fileNames.normal
                
                trackSettingsVC.volume = seq.volumes[index]
                
                trackSettingsVC.distortionWetDryMix = seq.distortionWetDryMixes[index]
                trackSettingsVC.distortionPreGain = seq.distortionPreGains[index]
                trackSettingsVC.distortionPreset = seq.distortionPresets[index]
                
                trackSettingsVC.reverbWetDryMix = seq.reverbWetDryMixes[index]
                trackSettingsVC.reverbType = seq.reverbTypes[index]
                
                trackSettingsVC.delayWetDryMix = seq.delayWetDryMixes[index]
                trackSettingsVC.delayFeedback = seq.delayFeedbacks[index]
                trackSettingsVC.delayTime = seq.delayTimes[index]
                trackSettingsVC.delayPreset = seq.delayPresets[index]
                
                print("REV01 mix \(seq.reverbWetDryMixes[index])")
                print("REV01 type  \(seq.reverbTypes[index])")
            }
        }
        
        if segue.identifier == "goToLoadSaveVC" {
            let navVC = segue.destination
            let loadSaveVC = navVC.children.first as! LoadSaveVC
            //            let loadSaveVC = segue.destination as! LoadSaveVC
            //loadSaveVC.realm = self.realm
            loadSaveVC.delegate = self
            
            guard let snapShot = realm.objects(Snapshot.self).first else {return}
            print(snapShot.name)
            print(snapShot.soundsArray)
        }
        
        if segue.identifier == "goToSettings" {
            let settingsTableVC = segue.destination as! SettingsTableVC
            settingsTableVC.popoverPresentationController?.delegate = self
            settingsTableVC.delegate = self
            //                trackSettingsVC.selectedSound = seq.selectedSounds[index]
            //                trackSettingsVC.fileNames = seq.fileNames.normal
            //                trackSettingsVC.currentPlayer = (sender as! UIButton).tag
            //                trackSettingsVC.volume = seq.volumes[index]
        }
        
        
        
    }
    
    //    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    //        return UIModalPresentationStyle.none
    //    }
    
    //
    // MARK:- TRACK SETTINGS
    //
    //    @IBAction func trackSettingsPressed(_ sender: UIButton) {
    //        print(#function)
    //       let trackVC = TrackSettingsVC()
    //     self.navigationController?.pushViewController(trackVC, animated: true)
    //
    //        //present(trackVC, animated: true) {
    //            //
    //       // }
    //        //performSegue(withIdentifier: "goToTrackSettingsVC", sender: self)
    //    }
    
    
    //
    // MARK:- Settings
    //
    @IBAction func showControlsToggle(_ sender: UIButton?) {
        
        print(#function)
        controlsHidden = !controlsHidden
        showOrHideControls()
        
        //        present(settingsVC, animated: true, completion: nil)
        
    }
    
    private func showOrHideControls() {
        
        if !controlsHidden {
            //
            // Show controls
            //
            
            //            trackCellsView.isHidden = false
            //            trackControlsLabelsStackView.isHidden = false
            //
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
        
        if let tempo = seq.tempo {
            seq.changeTempoAndPrescheduleBuffers(bpm: tempo.bpm)
        }
        
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
        seq.volumes[sender.tag] = Float(Double(sender.value))
        
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
        seq.displayedTracks[sender.tag].reverbMix = Double(sender.value)
        seq.reverbs[sender.tag].wetDryMix = sender.value
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
    
    //    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    //        return NSAttributedString(string: parksPickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    //    }
    
    
    //
    // MARK:- Tempo changed, update UI Tempo Elements
    //
    func updateUIAfterTempoChange(to newTempo: Double, restart: Bool? = true) {
        
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
        // Stop timers
        //
        for timerIndex in 0...(K.Sequencer.numberOfTracks - 1) {
            if timers[timerIndex].isValid {
                timers[timerIndex].invalidate()
            }
            timerEventCounterArray[timerIndex] = 0
            currentStepIndexArray[timerIndex] = 0
            seq.cellsToWaitBeforeReschedulingArray[timerIndex] = 0
        }
        
        if timer_x != nil {
            timer_x.invalidate()
        }
        
        if let tempo = seq.tempo {
            seq.changeTempoAndPrescheduleBuffers(bpm: tempo.bpm)
        }
        
        preScheduleFirstGuideBuffer()
        
        //
        //  Start again
        //
        if state == .run {
            startPlayers()
            startAllTimers()
        }
    }
}

extension MainVC {
    
    func printFrameLengths() {
        
        //        print(self.seq.soundBuffers.normal[0].frameLength, self.seq.silenceBuffers[0].frameLength, "  ",
        //              self.seq.soundBuffers.normal[1].frameLength, self.seq.silenceBuffers[1].frameLength, "  ",
        //              self.seq.soundBuffers.normal[2].frameLength, self.seq.silenceBuffers[2].frameLength, "  ",
        //              self.seq.soundBuffers.normal[3].frameLength, self.seq.silenceBuffers[3].frameLength, "  ",
        //              self.seq.guideBuffer.frameLength
        //        )
    }
}
