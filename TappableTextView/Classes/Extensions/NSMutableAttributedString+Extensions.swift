//
//  NSMutableAttributedString+Extensions.swift
//  TappableTextView
//
//  Created by Willie Johnson on 8/7/21.
//

import Foundation

extension NSMutableAttributedString {
  func withSize(_ size: CGFloat ) -> NSMutableAttributedString {
    let attributes = self.attributes(at: 0, effectiveRange: nil)
    let font = (attributes[NSMutableAttributedString.Key.font] as! UIFont).withSize(size)

    self.addAttribute(NSMutableAttributedString.Key.font, value: font, range:
                        NSRange(location: 0, length: mutableString.length))

    return self
  }

  func bold(_ value: String) -> NSMutableAttributedString {

      let attributes:[NSAttributedString.Key : Any] = [
        .font: Style.boldFont
      ]

      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
  }


  func semiBold(_ value: String) -> NSMutableAttributedString {

      let attributes:[NSAttributedString.Key : Any] = [
        .font: Style.semiBoldFont
      ]

      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
  }

  func normal(_ value:String) -> NSMutableAttributedString {

      let attributes:[NSAttributedString.Key : Any] = [
        .font: Style.normalFont,
      ]

      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
  }
  /* Other styling methods */
  func orangeHighlight(_ value:String) -> NSMutableAttributedString {

      let attributes:[NSAttributedString.Key : Any] = [
        .font:  Style.normalFont,
          .foregroundColor: UIColor.white,
          .backgroundColor: UIColor.orange
      ]

      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
  }

  func blackHighlight(_ value:String) -> NSMutableAttributedString {

      let attributes:[NSAttributedString.Key : Any] = [
        .font:  Style.normalFont,
          .foregroundColor: UIColor.white,
          .backgroundColor: UIColor.black

      ]

      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
  }

  func underlined(_ value:String) -> NSMutableAttributedString {

      let attributes:[NSAttributedString.Key : Any] = [
        .font :  Style.normalFont,
          .underlineStyle : NSUnderlineStyle.single.rawValue

      ]

      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
  }

  func withColor(_ color: UIColor) -> NSMutableAttributedString {
    self.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: color, range:
                        NSRange(location: 0, length: mutableString.length))
    return self
  }
}
