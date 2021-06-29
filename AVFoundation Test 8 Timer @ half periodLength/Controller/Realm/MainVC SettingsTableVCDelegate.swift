//
//  MainVC SettingsTableVCDelegate.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 23.05.21.
//

import Foundation
import RealmSwift

extension MainVC: SettingsTableVCDelegate, LoadSaveVCDelegate  {
    
    //
    // MARK:- Saves all data to snapshot named "name". Will NOT first check if snapshot already exists!
    //
    internal func saveSnapshotIfNotThere(_ name: String) {
        
        //
        // Simply saving new snapshot if not there
        //
        print("Saving new snapshot named \(name)")
        
        //
        // Add patterns to snapshot
        //
        var snParts = [SNPart]()
        for snPartIndex in 0...(K.Sequencer.numberOfParts - 1) {
            var snPatterns = [SNPattern]()
            for snPatternIndex in 0...(K.Sequencer.numberOfTracks - 1) {
                if let currentPartName = PartNames(rawValue: snPartIndex),
                   let currentPart = seq.parts[currentPartName]
                {
                    let currentArrayOfCells = currentPart.patterns[snPatternIndex].cells
                    //print("currentArrayOfCells: \(currentArrayOfCells)")
                    
                    let currentArrayOfStrings = cellArrayToStringArray(cellArray: currentArrayOfCells)
                    //print("currentArrayOfStrings: \(currentArrayOfStrings)")
                    
                    snPatterns.append(SNPattern.create(withName: "\(name) SNPattern \(snPartIndex) \(snPatternIndex)", cells: currentArrayOfStrings))
                }
            }
            snParts.append(SNPart.create(withName: "\(name) SNPart \(snPartIndex)", snPatterns: snPatterns))
            
        }
        let snapshot = Snapshot.create(withName: name, snParts: snParts)
        
        //
        // Add track volumes to snapshot
        //
        for trackIndex in 0...(K.Sequencer.numberOfTracks-1) {
            snapshot.volumesArray[trackIndex] = seq.volumes[trackIndex]
        }
        
        
        //
        // Add sound to snapshot
        //
        snapshot.soundsArray.removeAll()
        snapshot.soundsArray.append(objectsIn: seq.selectedSounds)
        
        //
        // Add tempo to snapshot
        //
        if let tempo = seq.tempo {
            snapshot.bpm = tempo.bpm
        }
        
        //
        // Write snapshot
        //
        try! realm.write {
            realm.add(snapshot)
        }
    }
    
    //
    // MARK:- SAVE
    //
    // If snapshot named "name" doesn't yet exist, saves all data to new snapshot.
    // If it exists, and partThatHasChanged and patternThatHasChanged are not provided, it will be deleted and overwritten
    //  If patternThatHasChanged and patternThatHasChanged are provided: Only that part/pattern of existing snapshot will be changed.
    //
    internal func saveSnapshot(name: String, partThatHasChanged: Int? = nil, patternThatHasChanged: Int? = nil) {
        
        if let handleToSnapshot = realm.objects(Snapshot.self).filter("name = %@", name).first {
            
            //
            // Snapshot does already exist
            //
            print("Snapshot named \(name) already there!")
            
            
            //
            // Write patterns to snapshot
            //
            if let prt = partThatHasChanged, let pttrn = patternThatHasChanged {
                
                //
                // Only changing partThatHasChanged / patternThatHasChanged
                //
                print("Will only change part \(prt) pattern \(pttrn).")
                try! realm.write {
                    handleToSnapshot.snParts[prt].snPatterns[pttrn].cells.removeAll()
                    //                    let data = allParts[prt][pttrn]
                    
                    if let partName = PartNames(rawValue: prt),
                       let dataAsArrayOfCell = seq.parts[partName]?.patterns[pttrn].cells {
                        
                        let dataAsArrayOfString = cellArrayToStringArray(cellArray: dataAsArrayOfCell)
                        
                        handleToSnapshot.snParts[prt].snPatterns[pttrn].cells.append(objectsIn:dataAsArrayOfString)
                    }
                }
                
            } else {
                
                //
                // Deleting old
                //
                print("Overwriting old file \(name).")
                
                deleteSnapshot(name)
                
                //
                // Writing new
                //
                saveSnapshotIfNotThere(name)
            }
            
        } else {
            
            //
            // Snapshot does not yet exist, so save it!
            //
            saveSnapshotIfNotThere(name)
        }
    }
    
    
    //
    // MARK:- LOAD
    //
    internal func loadSnapshot(_ name: String) {
        
        if let snapshot = realm.objects(Snapshot.self).filter("name = %@", name).first {
            print("Loading snapshot \(name)")
            
            //
            // Load sounds:
            //
            for (index, sound) in snapshot.soundsArray.enumerated() {
                loadFile(name: sound, toPlayer: index)
            }
            
            //
            // Load bpm:
            //
//            seq.tempo?.bpm = snapshot.bpm
            seq.changeTempoAndPrescheduleBuffers(bpm: snapshot.bpm)
            updateUIAfterTempoChange(to: snapshot.bpm)
            
            //
            // Load volumes
            //
            for trackIndex in 0...(K.Sequencer.numberOfTracks-1) {
                seq.volumes[trackIndex] = snapshot.volumesArray[trackIndex]
                seq.players[trackIndex].volume = snapshot.volumesArray[trackIndex]
            }
            
            //
            // Load patterns:
            //
            for partIndex in 0...(K.Sequencer.numberOfParts - 1) {
                for patternIndex in 0...(K.Sequencer.numberOfTracks - 1){
                    
                    //
                    // Read pattern from snapshot
                    //
                    let patternAslistOfString = snapshot.snParts[partIndex].snPatterns[patternIndex].cells
                    //print("patternAslistOfString: \(patternAslistOfString)")
                    
                    //
                    // Write pattern to Array
                    //
                    //
                    if let partName = PartNames(rawValue: partIndex) {
                        seq.parts[partName]?.patterns[patternIndex].cells = stringListToCellArray(stringList: patternAslistOfString)
                    }
                }
            }
            
            saveSnapshot(name: "default")
            
        } else {
            print("Snapshot \(name) does not exist")
            return
        }
        
    }
    
    //
    // MARK:- DELETE snaphot and its parts and patterns
    //
    internal func deleteSnapshot(_ snapshotName: String) {
        
        if let handleToSnapshot = realm.objects(Snapshot.self).filter("name = %@", snapshotName).first {
            
            try! realm.write {
                // Delete snapshot
                realm.delete(handleToSnapshot)
                
                // Delete parts & patterns too
                let snapshotNamePlusSpace = snapshotName + " "
                
                let handleToParts = realm.objects(SNPart.self).filter("name BEGINSWITH %@", snapshotNamePlusSpace)
                realm.delete(handleToParts)
                
                let handleToPatterns = realm.objects(SNPattern.self).filter("name BEGINSWITH %@", snapshotNamePlusSpace)
                realm.delete(handleToPatterns)
            }
            
        } else {
            print("Snapshot not found!")
        }
    }
    
    
    
    
}
