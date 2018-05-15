//
//  TappableTextView.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/4/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

@IBDesignable
class TappableTextView: UIView {
  @IBOutlet var contentView: UITextView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
}

// MARK: - Helper methods
private extension TappableTextView {
  /// Configure the UITextView with the required gestures to make text in the view tappable.
  func setupView() {
    contentView = loadNib(viewType: UITextView.self)
    contentView.backgroundColor = .clear
    addSubview(contentView)
    contentView.constrain(to: self)
    
    let textTapGesture = UITapGestureRecognizer(target: self, action: #selector(textTapped(recognizer:)))
    textTapGesture.numberOfTapsRequired = 1
    contentView.addGestureRecognizer(textTapGesture)
  }

  /// Handle taps on the UITextView.
  ///
  /// - Parameter recognizer: The UITapGestureRecognizer that triggered this handler.
  @objc func textTapped(recognizer: UITapGestureRecognizer) {
    // Grab UITextView and its content.
    guard let textView = recognizer.view as? UITextView else {
      return
    }
    // Grab the word.
    var tapLocation = recognizer.location(in: textView)
    guard let word = getWordAt(point: tapLocation, textView: textView) else { return }
    let highlight = HighlightView(word: word)
    textView.addSubview(highlight)
    // Animate highlight
    highlight.alpha = 0.2
    highlight.transform = .init(scaleX: 0.01, y: 1)
    UIView.animate(withDuration: 0.2, animations: {
      highlight.alpha = 1
      highlight.transform = .identity
    }) { _ in
//      UIView.animate(withDuration: 0.6, delay: 0.5, options: [], animations: {
//        highlight.alpha = 0
//        highlight.transform = .init(scaleX: 1, y: 0.01)
//      }, completion: ({ _ in
//        guard highlight.tapped else { return }
//        highlight.removeFromSuperview()
//      }))
    }
    // Animate the word being tapped by highlighting it in red.
  }

  /// Return the word that was tapped within the textview.
  ///
  /// - Paremeters:
  ///   - point: A position within the tapped UITextView.
  ///   - textView: The textView that was tappped.
  func getWordAt(point: CGPoint, textView: UITextView) -> Word? {
    guard let textPosition = textView.closestPosition(to: point) else { return nil }
    guard let textRange = textView.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: 1) else { return nil }

    let location = textView.offset(from: textView.beginningOfDocument, to: textRange.start)
    let length = textView.offset(from: textRange.start, to: textRange.end)
    guard let wordText = textView.text(in: textRange) else { return nil }
    let wordRange = NSRange(location: location, length: length)
    let wordRect = textView.firstRect(for: textRange)
    return Word(text: wordText, range: wordRange, rect: wordRect)
  }
}
