//
//  DefaultPatterns.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 08.05.21.
//

struct Patterns {
    
    var kick: [Pattern] = [
        Pattern(length: 16, data:
                    [
                        .ON, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .ON, .OFF, .OFF, .ON,
                        .OFF, .ON, .OFF, .OFF,
                        .OFF, .OFF, .ON, .OFF,
                        .ON, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ])
    ]
    
    var snare: [Pattern] = [
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .ON,
                        .OFF, .OFF, .ON, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ])
    ]
    
    var closed_hihat: [Pattern] = [
        Pattern(length: 16, data:
                    [
                        .ON, .OFF, .ON, .OFF,
                        .ON, .OFF, .ON, .OFF,
                        .ON, .OFF, .ON, .OFF,
                        .ON, .OFF, .ON, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .ON, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ])
    ]
    
    var open_hihat: [Pattern] = [
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .ON, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .ON, .OFF,
                        .OFF, .OFF, .ON, .OFF,
                        .OFF, .OFF, .ON, .OFF,
                        .OFF, .OFF, .ON, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, data:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ])
    ]
    
}
