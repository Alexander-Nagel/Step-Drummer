//
//  getCoordinates.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 16.05.21.
//

// https://stackoverflow.com/a/54350666/14506724


import Foundation
import UIKit

/// Returns Coordinates in relation to the most superest superview :-)
/// - Parameters:
///   - targetView: The View for which the coordinates shall be expressed in relation to the highest order super view.
///   - baseView: Name of the super view.
/// - Returns: Coordinates in CGPoint format
func getConvertedPoint(_ targetView: UIView, baseView: UIView)->CGPoint{
    var pnt = targetView.frame.origin
    if nil == targetView.superview{
        return pnt
    }
    var superView = targetView.superview
    while superView != baseView{
        pnt = superView!.convert(pnt, to: superView!.superview)
        if nil == superView!.superview{
            break
        }else{
            superView = superView!.superview
        }
    }
    return superView!.convert(pnt, to: baseView)
}
