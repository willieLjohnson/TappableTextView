//
//  Word.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/10/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import UIKit

public struct Word {
  var text: String
  var range: NSRange
  var rect: CGRect

  public func getText() -> String {
    return text;
  }
}

