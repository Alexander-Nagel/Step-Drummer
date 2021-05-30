//
//  SyncDelay.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 29.05.21.
//

import Foundation

enum SyncDelay: Int, CaseIterable {
    
    case bar = 0                    // 1
    case half = 3                   // 0.5
    case quarter = 6                // 0.25
    case eighth = 9                 // 0.125
    case sixteenth = 12             // 0.0625
    case thirtysecond = 15          // 0.03125
    case dottedHalf = 1             // 0.75
    case dottedQuarter = 4          // 0.375
    case dottedEighth = 7           // 0.1875
    case dottedSixteenth = 10       // 0.09375
    case dottedThirtysecond = 13    // 0.046875
    case tripletHalf = 2            // 0.666666
    case tripletQuarter = 5         // 0.333333
    case tripletEighth = 8          // 0.166666
    case tripletSixteenth = 11      // 0.083333
    case tripletThirtysecond = 14   // 0.0416666
    
   var description: String {
        switch self {
        case .bar:
            return "1 bar"
        case .half:
            return "1/2"
        case .quarter:
            return "1/4"
        case .eighth:
            return "1/8"
        case .sixteenth:
            return "1/16"
        case .thirtysecond:
            return "1/32"
        case .dottedHalf:
            return "dotted 1/2"
        case .dottedQuarter:
            return "dotted 1/4"
        case .dottedEighth:
            return "dotted 1/8"
        case .dottedSixteenth:
            return "dotted 1/16"
        case .dottedThirtysecond:
            return "dotted 1/32"
        case .tripletHalf:
            return "triplet 1/2"
        case .tripletQuarter:
            return "triplet 1/4"
        case .tripletEighth:
            return "triplet 1/8"
        case .tripletSixteenth:
            return "triplet 1/16"
        case .tripletThirtysecond:
            return "triplet 1/32"
        }
    }
    
    var factor: Double {
         switch self {
         case .bar:
             return 1
         case .half:
            return 0.5
         case .quarter:
            return 0.25
         case .eighth:
            return 0.125
         case .sixteenth:
            return 0.0625
         case .thirtysecond:
             return 0.03125
         case .dottedHalf:
             return 0.75
         case .dottedQuarter:
             return 0.375
         case .dottedEighth:
             return 0.1875
         case .dottedSixteenth:
             return 0.09375
         case .dottedThirtysecond:
             return 0.046875
         case .tripletHalf:
             return 0.666666
         case .tripletQuarter:
             return 0.333333
         case .tripletEighth:
             return 0.166666
         case .tripletSixteenth:
             return 0.083333
         case .tripletThirtysecond:
             return 0.0416666
         }
     }
 
    
    
}

//struct SyncDelay {
//
//    static var names = ["1 bar", "1/2", "1/4", "1/8", "1/16", "1/32",
//                          "dotted 1/2", "dotted 1/4", "dotted 1/8", "dotted 1/16", "dotted 1/32",
//                          "triplet 1/2", "triplet 1/4", "triplet 1/8", "triplet 1/16", "triplet 1/32" ]
//    static var times = [1, 0.5, 0.25, 0.125, 0.0625, 0.03125,
//                        0.75, 0.375, 0.1875, 0.09375, 0.046875,
//                        0.666666, 0.333333, 0.166666, 0.083333, 0.0416666]
//    static var count = names.count
//
//    static var namesTimes: [String: Float] = ["1 bar": 1, "1/2": 0.5, "1/4": 0.25, "1/8": 0.125, "1/16": 0.0625, "1/32": 0.03125,
//        "dotted 1/2": 0.75, "dotted 1/4": 0.375, "dotted 1/8": 0.1875, "dotted 1/16": 0.09375, "dotted 1/32": 0.046875,
//        "triplet 1/2": 0.666666, "triplet 1/4": 0.333333, "triplet 1/8": 0.166666, "triplet 1/16": 0.083333, "triplet 1/32": 0.0416666 ]
//}
