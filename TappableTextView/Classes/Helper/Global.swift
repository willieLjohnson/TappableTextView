//
//  Compatibility.swift
//  TappableTextView
//
//  Created by Willie Johnson on 8/9/21.
//

import Foundation

enum Global {
  static var softImpactFeedbackGenerator: UIImpactFeedbackGenerator {
    get {
      if #available(iOS 13.0, *) {
        return UIImpactFeedbackGenerator(style: .soft)
      }
      return UIImpactFeedbackGenerator(style: .light)
    }
  }
}

