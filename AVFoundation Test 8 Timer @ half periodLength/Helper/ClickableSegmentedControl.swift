//
//  ClickableSegmentedControl.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 19.05.21.
//
// https://stackoverflow.com/a/55068536/14506724

import UIKit

class ClickableSegmentedControl: UISegmentedControl {
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event);
    self.sendActions(for: UIControl.Event.touchUpInside);
  }
}
