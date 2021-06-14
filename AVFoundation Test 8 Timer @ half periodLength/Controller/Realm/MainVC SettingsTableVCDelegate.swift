//
//  MainVC SettingsTableVCDelegate.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 23.05.21.
//

import Foundation
import RealmSwift

extension MainVC: SettingsTableVCDelegate, LoadSaveVCDelegate  {
    
    //    fileprivate func copyDataToSnapshot(_ snapshot: Snapshot, _ snapshotName: String) {
    //
    //        snapshot.name = snapshotName
    //        snapshot.soundsArray.append(objectsIn: seq.selectedSounds)
    //
    //        //
    //        // Copy parts to snapshot.parts
    //        //
    //        // Iterate over parts
    //        //
    //        for currentPartIndex in 0...(PartNames.numberOfParts - 1) {
    //
    //           // let patterns = List<SnapshotPattern>()
    //            let patterns = List<SNPattern>()
    //
    //
    //            //
    //            // Iterate over patterns in part, append pattern to currentSnapshotPart
    //            //
    //            for patternIndex in 0...(K.Sequencer.numberOfTracks - 1) {
    //
    //                if let currentPartName = PartNames(rawValue: currentPartIndex),
    //                   let currentPart = seq.parts[currentPartName]
    //                {
    //                    let currentPattern = currentPart.patterns[patternIndex]
    //                    let currentCellArray = currentPattern.cells
    //
    //                    //
    //                    // Convert to array of String for Realm
    //                    //
    //                    let currentStringArray = cellArrayToStringArray(cellArray: currentCellArray)
    //
    //                    //
    //                    // Create new pattern
    //                    //
    //                    let cells = List<String>()
    //                    cells.append(objectsIn: currentStringArray)
    //                    print("cells: ", cells)
    //
    //                    //
    //                    // Append pattern to patterns
    //                    //
    //                    //patterns.append(SnapshotPattern(value: ["cells": cells]))
    //                    patterns.append(SNPattern(value: ["cells": cells]))
    //                    print("patterns: ", patterns)
    //                }
    //            }
    //            //            let patternsToDelete = realm.objects(SnapshotPattern.self)
    //            //            realm.delete(patternsToDelete)
    //
    //            //
    //            // Append part to parts
    //            //
    //            //snapshot.parts.append(SnapshotPart(value: ["patterns": patterns]))
    //            snapshot.snParts.append(SNPart(value: ["patterns": patterns]))
    //            //print("snapshot.parts: ", snapshot.parts)
    //            print("snapshot.snParts: ", snapshot.snParts)
    //
    //        }
    //
    //        //        let partsToDelete = realm.objects(SnapshotPart.self)
    //        //        realm.delete(partsToDelete)
    //
    //    }
    
    //
    // MARK:- Saves all data to snapshot named "name". Will NOT first check if snapshot already exists!
    //
    internal func saveSnapshotIfNotThere(_ name: String) {
        
        //
        // Simply saving new snapshot if not there
        //
        print("Saving new snapshot named \(name)")
        var snParts = [SNPart]()
        for snPartIndex in 0...(K.Sequencer.numberOfParts - 1) {
            var snPatterns = [SNPattern]()
            for snPatternIndex in 0...(K.Sequencer.numberOfTracks - 1) {
                if let currentPartName = PartNames(rawValue: snPartIndex),
                   let currentPart = seq.parts[currentPartName]
                {
                    let currentArrayOfCells = currentPart.patterns[snPatternIndex].cells
                    print("currentArrayOfCells: \(currentArrayOfCells)")
                    
                    let currentArrayOfStrings = cellArrayToStringArray(cellArray: currentArrayOfCells)
                    print("currentArrayOfStrings: \(currentArrayOfStrings)")
                    
                    snPatterns.append(SNPattern.create(withName: "\(name) SNPattern \(snPartIndex) \(snPatternIndex)", cells: currentArrayOfStrings))
                }
            }
            snParts.append(SNPart.create(withName: "\(name) SNPart \(snPartIndex)", snPatterns: snPatterns))
            
        }
        let snapshot = Snapshot.create(withName: name, snParts: snParts)
        
        snapshot.soundsArray.append(objectsIn: seq.selectedSounds)
        
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
    
    
    
  
    //    internal func saveSnapShot(fileName: String) {
    //
    //        //
    //        // Check if snapshot already exits, if yes modify it, otherwise create it:
    //        //
    //        if let snapshot = realm.objects(Snapshot.self).filter("name == %@", fileName).first {
    //            //
    //            // if defaultSnapShot already exists, modify it:
    //            //
    //            do {
    //                try realm.write {
    //                    //realm.delete(snapshot)
    //
    //                    // let newSnapshot = Snapshot()
    //                    snapshot.name = ""
    //                    snapshot.soundsArray.removeAll()
    //                    //snapshot.parts.removeAll()
    //
    //
    //
    //                    copyDataToSnapshot(snapshot, fileName)
    //
    //                    realm.add(snapshot)
    //
    //                    //
    //                    // Clean up, only Snaphot objects will be left in Realm
    //                    //
    //                    //                    let parts = realm.objects(SnapshotPart.self)
    //                    //                    realm.delete(parts)
    //                    //                    let patterns = realm.objects(SnapshotPattern.self)
    //                    //                    realm.delete(patterns)
    //
    //                }
    //            } catch {
    //                print("error writing to realm \(error)")
    //            }
    //        } else {
    //            //
    //            // otherwise create it:
    //            //
    //            let snapshot = Snapshot()
    //            //            let cells = List<String>()
    //            //            let patterns = List<SnapshotPattern>()
    //
    //            copyDataToSnapshot(snapshot, fileName)
    //
    //            do {
    //                try realm.write {
    //                    realm.add(snapshot)
    //
    //                    //
    //                    // Clean up, only Snaphot objects will be left in Realm
    //                    //
    //                    //                    let parts = realm.objects(SnapshotPart.self)
    //                    //                    realm.delete(parts)
    //                    //                    let patterns = realm.objects(SnapshotPattern.self)
    //                    //                    realm.delete(patterns)
    //                }
    //            } catch {
    //                print("error writing to realm \(error)")
    //            }
    //        }
    //    }
    
   
    
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
            // Load patterns:
            //
            for partIndex in 0...(K.Sequencer.numberOfParts - 1) {
                for patternIndex in 0...(K.Sequencer.numberOfTracks - 1){
                    
                    //
                    // Read pattern from snapshot
                    //
                    let patternAslistOfString = snapshot.snParts[partIndex].snPatterns[patternIndex].cells
                    print("patternAslistOfString: \(patternAslistOfString)")
                    
                    //
                    // Write pattern to Array
                    //
                    //                    allParts[partIndex][patternIndex].removeAll()
                    //                    allParts[partIndex][patternIndex].append(contentsOf: patternAslistOfString)
                    
                    if let partName = PartNames(rawValue: partIndex) {
                        seq.parts[partName]?.patterns[patternIndex].cells = stringListToCellArray(stringList: patternAslistOfString)
                    }
                }
            }
        } else {
            print("Snapshot \(name) does not exist")
            return
        }
        
    }
    
    
    //    func loadSnapShot(fileName: String) {
    //        //print("loooood \(fileName)")
    //
    //        //
    //        // Check if defaultSnapShot exits
    //        //
    //        if let defaultSnapShot = realm.objects(Snapshot.self).filter("name == \"default\"").first {
    //
    //            //
    //            // exists
    //            //
    //
    //            //
    //            // Load sounds:
    //            //
    //            for (index, sound) in defaultSnapShot.soundsArray.enumerated() {
    //                //seq.selectedSounds[index] = sound
    //                //print("index: \(index), sound: \(sound)")
    //                loadFile(name: sound, toPlayer: index)
    //            }
    //
    //
    //            //
    //            // Load parts:
    //            //
    //            // Iterate over parts
    //            //
    //            for partIndex in 0...(PartNames.numberOfParts - 1) {
    //
    //                // Iterate over patterns in current part
    //                //
    //                for patternIndex in 0...(K.Sequencer.numberOfTracks - 1 ) {
    //
    //                    if let partName = PartNames(rawValue: partIndex) {
    //                        seq.parts[partName]?.patterns[patternIndex].cells = stringListToCellArray(stringList: defaultSnapShot.parts[partIndex].patterns[patternIndex].cells)
    //                    }
    //                }
    //            }
    //
    //        } else {
    //
    //            //
    //            // doesn't exist
    //            //
    //        }
    //    }
    
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
