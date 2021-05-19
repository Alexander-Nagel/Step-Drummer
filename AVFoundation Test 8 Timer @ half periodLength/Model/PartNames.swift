//
//  Part.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 19.05.21.
//

enum PartNames: Int, CaseIterable {
    case A, B, C, D
    
    func next() -> PartNames {
        let currentIndex = self.rawValue
        var nextIndex = currentIndex + 1
        if nextIndex == PartNames.allCases.count {
            nextIndex = 0
        }
        guard let next = PartNames(rawValue: nextIndex) else {
            fatalError("Error iteraing over PartName!")
        }
        return next
    }
}
