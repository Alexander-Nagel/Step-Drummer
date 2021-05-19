//
//  DefaultPatterns.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 08.05.21.
//

struct DefaultPatterns {
    
    var kick: [Pattern] = [
        Pattern(length: 16, cells:
                    [
                        .ON, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, cells:
                    [
                        .ON, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .ON, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, cells:
                    [
                        .ON, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .ON, .OFF,
                        .ON, .ON, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, cells:
                    [
                        .ON, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .ON, .OFF,
                        .ON, .ON, .OFF, .ON,
                        .OFF, .OFF, .OFF, .OFF
                    ])
    ]
    
    var snare: [Pattern] = [
        Pattern(length: 16, cells:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, cells:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .SOFT,
                        .OFF, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, cells:
                    [
                        .OFF, .SOFT, .OFF, .OFF,
                        .ON, .OFF, .OFF, .SOFT,
                        .OFF, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF

                    ]),
        Pattern(length: 16, cells:
                    [
                        .OFF, .SOFT, .OFF, .OFF,
                        .ON, .OFF, .OFF, .SOFT,
                        .OFF, .OFF, .OFF, .SOFT,
                        .ON, .OFF, .SOFT, .SOFT
                    ])
    ]
    
    var closed_hihat: [Pattern] = [
        Pattern(length: 16, cells:
                    [
                        .ON, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                        .ON, .OFF, .OFF, .OFF,
                    ]),
        Pattern(length: 16, cells:
                    [
                        .ON, .OFF, .ON, .OFF,
                        .ON, .OFF, .ON, .OFF,
                        .ON, .OFF, .ON, .OFF,
                        .ON, .OFF, .ON, .OFF,
                    ]),
        Pattern(length: 16, cells:
                    [
                        .ON, .OFF, .ON, .OFF,
                        .ON, .OFF, .ON, .SOFT,
                        .ON, .OFF, .ON, .OFF,
                        .ON, .OFF, .ON, .SOFT,
                    ]),
        Pattern(length: 16, cells:
                    [
                        .ON, .SOFT, .ON, .SOFT,
                        .ON, .SOFT, .ON, .SOFT,
                        .ON, .SOFT, .ON, .OFF,
                        .ON, .SOFT, .ON, .SOFT,
                    ])
    ]
    
    var open_hihat: [Pattern] = [
        Pattern(length: 16, cells:
                    [
                        .ON, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .OFF, .OFF
                    ]),
        Pattern(length: 16, cells:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .ON, .OFF,
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .ON, .OFF
                    ]),
        Pattern(length: 16, cells:
                    [
                        .OFF, .OFF, .OFF, .OFF,
                        .OFF, .OFF, .ON, .OFF,
                        .OFF, .SOFT, .OFF, .OFF,
                        .OFF, .OFF, .ON, .OFF
                    ]),
        Pattern(length: 16, cells:
                    [
                        .OFF, .OFF, .ON, .OFF,
                        .OFF, .OFF, .ON, .OFF,
                        .OFF, .SOFT, .ON, .OFF,
                        .OFF, .OFF, .ON, .OFF
                    ])
    ]
    
}
