//
//  Parts.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 19.05.21.
//

import Foundation

struct Part {
    var patterns = [Pattern]()
    init() {
        patterns = Array(repeating: Pattern(length: 16, cells: [.OFF, .OFF,.OFF,.OFF,.OFF,.OFF,.OFF,.OFF,.OFF,.OFF,.OFF,.OFF,.OFF,.OFF,.OFF,.OFF]), count: 4)
    }
}
