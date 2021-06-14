//
//  Snaphot2.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 14.06.21.
//

import Foundation
import RealmSwift

//final class SnapshotPattern: Object {
//    let cells = List<String>()
//}

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

//final class SnapshotPart: Object {
//    let patterns = List<SnapshotPattern>()
//}

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


//final class Snapshot: Object {
//    @objc dynamic var name: String = ""
//    let soundsArray = List<String>()
//    let parts = List<SnapshotPart>()
//}

final class Snapshot: Object {
    @objc dynamic var name = ""
    var soundsArray = List<String>()
    var snParts = List<SNPart>()
    
    static func create(withName name: String, snParts: [SNPart]) -> Snapshot {
        let snapshot = Snapshot()
        snapshot.name = name
        snapshot.snParts.append(objectsIn: snParts)
        return snapshot
    }
}
