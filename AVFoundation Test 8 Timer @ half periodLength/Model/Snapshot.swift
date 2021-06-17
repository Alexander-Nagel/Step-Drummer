//NEW!
//
//  Snaphot.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 14.06.21.
//

import Foundation
import RealmSwift

final class SNPattern: Object {
    @objc dynamic var name = ""
    var cells = List<String>()
    
    static func create(withName name: String, cells: [String]) -> SNPattern {
        let snPattern = SNPattern()
        snPattern.name = name
        snPattern.cells.append(objectsIn: cells)
        return snPattern
    }
}

final class SNPart: Object {
    @objc dynamic var name = ""
    var snPatterns = List<SNPattern>()
    
    static func create(withName name: String, snPatterns: [SNPattern]) -> SNPart {
        let snPart = SNPart()
        snPart.name = name
        snPart.snPatterns.append(objectsIn: snPatterns)
        return snPart
    }
}

final class Snapshot: Object {
    @objc dynamic var name = ""
    
    @objc dynamic var bpm: Double = 120.0
    
    var volumesArray = List<Float>()

    var soundsArray = List<String>()
    
    var snParts = List<SNPart>()
    
    static func create(withName name: String, snParts: [SNPart]) -> Snapshot {
        let snapshot = Snapshot()
        snapshot.name = name
        snapshot.volumesArray.append(objectsIn: Array(repeating: 0.0, count: K.Sequencer.numberOfTracks))
        snapshot.soundsArray.append(objectsIn: Array(repeating: "", count: K.Sequencer.numberOfTracks))
        snapshot.snParts.append(objectsIn: snParts)
        return snapshot
    }
}
