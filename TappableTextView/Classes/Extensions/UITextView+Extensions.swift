//
//  UITextView+Extensions.swift
//  Pods-TappableTextView_Example
//
//  Created by Willie Johnson on 8/12/21.
//

import Foundation

public extension UITextView {
  /// Return the word that was tapped within the textview.
  ///
  /// - Paremeters:
  ///   - point: A position within the tapped UITextView.
  ///   - textView: The textView that was tappped.
  func getWordAt(point: CGPoint) -> Word? {
    guard let textPosition = closestPosition(to: point) else { return nil }
    guard let textRange = tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: UITextDirection(rawValue: 1)) else { return nil }
    let location = offset(from: beginningOfDocument, to: textRange.start)
    let length = offset(from: textRange.start, to: textRange.end)
    guard let wordText = text(in: textRange) else { return nil }
    let wordRange = NSRange(location: location, length: length)
    let wordRect = firstRect(for: textRange)
    return Word(text: wordText, range: wordRange, rect: wordRect)
  }

}
