//
//  MainVC SettingsTableVCDelegate.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 23.05.21.
//

import Foundation

extension MainVC: SettingsTableVCDelegate  {
    
    func loadSnapShot(fileName: String) {
        print("loooood \(fileName)")
        
        //
        // Check if defaultSnapShot exits
        //
        if let defaultSnapShot = realm.objects(SnapShot.self).filter("name == \"default\"").first {
            //
            // exists
            //
            for (index, sound) in defaultSnapShot.soundsArray.enumerated() {
                //seq.selectedSounds[index] = sound
                print("index: \(index), sound: \(sound)")
                loadFile(name: sound, toPlayer: index)
            }
           print()
            
            seq.parts[.A]?.patterns[0].cells = stringListToCellArray(stringList: defaultSnapShot.patternA0)
            seq.parts[.A]?.patterns[1].cells = stringListToCellArray(stringList: defaultSnapShot.patternA1)
            seq.parts[.A]?.patterns[2].cells = stringListToCellArray(stringList: defaultSnapShot.patternA2)
            seq.parts[.A]?.patterns[3].cells = stringListToCellArray(stringList: defaultSnapShot.patternA3)
            
            seq.parts[.B]?.patterns[0].cells = stringListToCellArray(stringList: defaultSnapShot.patternB0)
            seq.parts[.B]?.patterns[1].cells = stringListToCellArray(stringList: defaultSnapShot.patternB1)
            seq.parts[.B]?.patterns[2].cells = stringListToCellArray(stringList: defaultSnapShot.patternB2)
            seq.parts[.B]?.patterns[3].cells = stringListToCellArray(stringList: defaultSnapShot.patternB3)
            
            seq.parts[.C]?.patterns[0].cells = stringListToCellArray(stringList: defaultSnapShot.patternC0)
            seq.parts[.C]?.patterns[1].cells = stringListToCellArray(stringList: defaultSnapShot.patternC1)
            seq.parts[.C]?.patterns[2].cells = stringListToCellArray(stringList: defaultSnapShot.patternC2)
            seq.parts[.C]?.patterns[3].cells = stringListToCellArray(stringList: defaultSnapShot.patternC3)
            
            seq.parts[.D]?.patterns[0].cells = stringListToCellArray(stringList: defaultSnapShot.patternD0)
            seq.parts[.D]?.patterns[1].cells = stringListToCellArray(stringList: defaultSnapShot.patternD1)
            seq.parts[.D]?.patterns[2].cells = stringListToCellArray(stringList: defaultSnapShot.patternD2)
            seq.parts[.D]?.patterns[3].cells = stringListToCellArray(stringList: defaultSnapShot.patternD3)
           
            
            
        } else {
            
            //
            // doesn't exist
            //
            
        }
        
    }
    
    func saveSnapShot(fileName: String) {
        
        //
        // Check if defaultSnapShot already exits, if yes modify it, otherwise create it:
        //
        if let defaultSnapShot = realm.objects(SnapShot.self).filter("name == \"default\"").first {
            //
            // if defaultSnapShot already exists, modify it:
            //
            do {
                try realm.write {
                    defaultSnapShot.name = fileName
                    defaultSnapShot.soundsArray.removeAll()
                    defaultSnapShot.soundsArray.append(objectsIn: seq.selectedSounds)
                    
                    //
                    // copy seq.parts[.A] to realmPatternsA
                    //
                    if let pattern = seq.parts[.A]?.patterns {
                        let realmPatterns = [defaultSnapShot.patternA0, defaultSnapShot.patternA1, defaultSnapShot.patternA2, defaultSnapShot.patternA3]
                        for (index, realmPattern) in realmPatterns.enumerated() {
                            let cellArray = pattern[index].cells
                            let stringArray = cellArrayToStringArray(cellArray: cellArray)
                            realmPattern.removeAll()
                            realmPattern.append(objectsIn: stringArray)
                        }
                    }
                    
                    //
                    // copy seq.parts[.B] to realmPatternsB
                    //
                    if let pattern = seq.parts[.B]?.patterns {
                        let realmPatterns = [defaultSnapShot.patternB0, defaultSnapShot.patternB1, defaultSnapShot.patternB2, defaultSnapShot.patternB3]
                        for (index, realmPattern) in realmPatterns.enumerated() {
                            let cellArray = pattern[index].cells
                            let stringArray = cellArrayToStringArray(cellArray: cellArray)
                            realmPattern.removeAll()
                            realmPattern.append(objectsIn: stringArray)
                        }
                    }
                    
                    //
                    // copy seq.parts[.C] to realmPatternsC
                    //
                    if let pattern = seq.parts[.C]?.patterns {
                        let realmPatterns = [defaultSnapShot.patternC0, defaultSnapShot.patternC1, defaultSnapShot.patternC2, defaultSnapShot.patternC3]
                        for (index, realmPattern) in realmPatterns.enumerated() {
                            let cellArray = pattern[index].cells
                            let stringArray = cellArrayToStringArray(cellArray: cellArray)
                            realmPattern.removeAll()
                            realmPattern.append(objectsIn: stringArray)
                        }
                    }
                    
                    //
                    // copy seq.parts[.D] to realmPatternsD
                    //
                    if let pattern = seq.parts[.D]?.patterns {
                        let realmPatterns = [defaultSnapShot.patternD0, defaultSnapShot.patternD1, defaultSnapShot.patternD2, defaultSnapShot.patternD3]
                        for (index, realmPattern) in realmPatterns.enumerated() {
                            let cellArray = pattern[index].cells
                            let stringArray = cellArrayToStringArray(cellArray: cellArray)
                            realmPattern.removeAll()
                            realmPattern.append(objectsIn: stringArray)
                        }
                    }
                   
                }
            } catch {
                print("error writing to realm \(error)")
            }
        } else {
            //
            // otherwise create it:
            //
            let defaultSnapShot = SnapShot()
            defaultSnapShot.name = fileName
            defaultSnapShot.soundsArray.append(objectsIn: seq.selectedSounds)
            
            //
            // copy seq.parts[.A] to realmPatternsA
            //
            if let pattern = seq.parts[.A]?.patterns {
                let realmPatterns = [defaultSnapShot.patternA0, defaultSnapShot.patternA1, defaultSnapShot.patternA2, defaultSnapShot.patternA3]
                for (index, realmPattern) in realmPatterns.enumerated() {
                    let cellArray = pattern[index].cells
                    let stringArray = cellArrayToStringArray(cellArray: cellArray)
                    realmPattern.append(objectsIn: stringArray)
                }
            }
            
            //
            // copy seq.parts[.B] to realmPatternsB
            //
            if let pattern = seq.parts[.B]?.patterns {
                let realmPatterns = [defaultSnapShot.patternB0, defaultSnapShot.patternB1, defaultSnapShot.patternB2, defaultSnapShot.patternB3]
                for (index, realmPattern) in realmPatterns.enumerated() {
                    let cellArray = pattern[index].cells
                    let stringArray = cellArrayToStringArray(cellArray: cellArray)
                    realmPattern.append(objectsIn: stringArray)
                }
            }
            
            //
            // copy seq.parts[.C] to realmPatternsC
            //
            if let pattern = seq.parts[.C]?.patterns {
                let realmPatterns = [defaultSnapShot.patternC0, defaultSnapShot.patternC1, defaultSnapShot.patternC2, defaultSnapShot.patternC3]
                for (index, realmPattern) in realmPatterns.enumerated() {
                    let cellArray = pattern[index].cells
                    let stringArray = cellArrayToStringArray(cellArray: cellArray)
                    realmPattern.append(objectsIn: stringArray)
                }
            }
            
            //
            // copy seq.parts[.D] to realmPatternsD
            //
            if let pattern = seq.parts[.D]?.patterns {
                let realmPatterns = [defaultSnapShot.patternD0, defaultSnapShot.patternD1, defaultSnapShot.patternD2, defaultSnapShot.patternD3]
                for (index, realmPattern) in realmPatterns.enumerated() {
                    let cellArray = pattern[index].cells
                    let stringArray = cellArrayToStringArray(cellArray: cellArray)
                    realmPattern.append(objectsIn: stringArray)
                }
            }
            
            do {
                try realm.write {
                    realm.add(defaultSnapShot)
                }
            } catch {
                print("error writing to realm \(error)")
            }
        }
    }
}
