//
//  SoundSelectionTableVCDelegate.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 20.05.21.
//

import Foundation
extension MainVC: TrackSettingsVCDelegate {
    
    func loadFile(name: String, toPlayer player: Int) {
        //print("\(name) has been chosen to be loaded.")
        
        if let index = seq.fileNames.normal.firstIndex(of: name) {
            loadBuffer(ofPlayer: player, withFile: index)
            seq.selectedSounds[player] = seq.fileNames.normal[index]
        }
    }
    
    
}
