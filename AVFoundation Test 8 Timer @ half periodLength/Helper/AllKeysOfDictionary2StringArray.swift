//
//  AllKeysOfDictionary2StringArray.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 30.05.21.
//

import Foundation

extension Dictionary {
  func allKeys() -> [String] {
    guard self.keys.first is String else {
      debugPrint("This function will not return other hashable types. (Only strings)")
      return []
    }
    return self.compactMap { (anEntry) -> String? in
                          guard let temp = anEntry.key as? String else { return nil }
                          return temp }
  }
}
