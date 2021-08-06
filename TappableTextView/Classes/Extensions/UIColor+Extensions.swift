//
//  UIColor+Extensions.swift
//  Pods-TappableTextView_Example
//
//  Created by Willie Johnson on 5/20/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  /// Returns this UIColor's constrast color.
  public func contrastColor() -> UIColor {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    return UIColor(hue: hue, saturation: 1.4 - saturation, brightness: 1.1 - brightness, alpha: alpha)
  }

  public static func randomColor() -> UIColor {
    let randomHue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    return UIColor(hue: randomHue, saturation: 0.6, brightness: 0.9, alpha: 1)
  }

  public func darken(_ factor: Float = 1) -> UIColor {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    return UIColor(hue: hue, saturation: saturation, brightness: brightness * CGFloat(factor), alpha: alpha)
  }

  public func opposite() -> UIColor {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    return UIColor(hue: 1 - hue, saturation: 1 - saturation, brightness: 1 - brightness, alpha: alpha)
  }
}
