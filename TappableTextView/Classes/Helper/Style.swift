//
//  Style.swift
//  Vybes
//
//  Created by Willie Johnson on 4/15/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import UIKit

/// Holds the style guide of the app
public struct Style {
  static let accentColor: UIColor = #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1)
  static let contentColor: UIColor = #colorLiteral(red: 0.3490196078, green: 0.3450980392, blue: 0.4509803922, alpha: 1)
  static let shadowColor: CGColor = #colorLiteral(red: 0.3490196078, green: 0.3450980392, blue: 0.4509803922, alpha: 0.5)
  static let backgroundColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  static let normalFontSize: CGFloat = 15
  static let boldFontSize: CGFloat = 19
  static let semiBoldFontSize: CGFloat = 17
  static let boldFont: UIFont = UIFont(name: "AvenirNext-Bold", size: boldFontSize) ?? UIFont.boldSystemFont(ofSize:  boldFontSize)
  static let semiBoldFont: UIFont = UIFont(name: "AvenirNext-DemiBold", size: semiBoldFontSize) ?? UIFont.boldSystemFont(ofSize:  semiBoldFontSize)
  static let normalFont: UIFont = UIFont(name: "AvenirNext-Regular", size: normalFontSize) ?? UIFont.systemFont(ofSize:  normalFontSize)
}
