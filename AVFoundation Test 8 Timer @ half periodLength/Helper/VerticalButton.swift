//
//  VerticalButton.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 18.05.21.
//
// https://stackoverflow.com/a/61612337/14506724

import UIKit

class VerticalButton: UIButton {
  override func layoutSubviews() {
    super.layoutSubviews()
    let padding: CGFloat = 8
    let iH = imageView?.frame.height ?? 0
    let tH = titleLabel?.frame.height ?? 0
    let v: CGFloat = (frame.height - iH - tH - padding) / 2
    if let iv = imageView {
      let x = (frame.width - iv.frame.width) / 2
      iv.frame.origin.y = v
      iv.frame.origin.x = x
    }

    if let tl = titleLabel {
      let x = (frame.width - tl.frame.width) / 2
      tl.frame.origin.y = frame.height - tl.frame.height - v
      tl.frame.origin.x = x
    }
  }
}
