//
//  DefaultPatterns.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 08.05.21.
//

struct DefaultPatterns {
    
    static let kick1: Pattern = Pattern(length: 16, data:
                                    [
                                        .ON, .OFF, .OFF, .OFF,
                                        .ON, .OFF, .OFF, .OFF,
                                        .ON, .OFF, .OFF, .OFF,
                                        .ON, .OFF, .OFF, .OFF
                                    ])
    
    static let snare1: Pattern = Pattern(length: 16, data:
                                    [
                                        .OFF, .OFF, .OFF, .OFF,
                                        .ON, .OFF, .OFF, .OFF,
                                        .OFF, .OFF, .OFF, .OFF,
                                        .ON, .OFF, .OFF, .OFF
                                    ])
    
    static let closedHihat1: Pattern = Pattern(length: 16, data:
                                            [
                                                .ON, .OFF, .ON, .OFF,
                                                .ON, .OFF, .ON, .OFF,
                                                .ON, .OFF, .ON, .OFF,
                                                .ON, .OFF, .ON, .OFF
                                            ])
    
    static let openHihat1: Pattern = Pattern(length: 16, data:
                                        [
                                            .OFF, .OFF, .ON, .OFF,
                                            .OFF, .OFF, .ON, .OFF,
                                            .OFF, .OFF, .ON, .OFF,
                                            .OFF, .OFF, .ON, .OFF
                                        ])
}
