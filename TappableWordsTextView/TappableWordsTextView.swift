//
//  TappableWordsTextView.swift
//  TappableWordsTextView
//
//  Created by Willie Johnson on 5/4/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

@IBDesignable
class TappableWordsTextView: UIView {
  @IBOutlet var contentView: UITextView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
}

// MARK: - Helper methods
private extension TappableWordsTextView {
  /// Configure the UITextView with the required gestures to make text in the view tappable.
  func setupView() {
    contentView = loadNib(viewType: UITextView.self)
    addSubview(contentView)
    constrain(to: contentView)
    
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
    guard let mutableText = textView.attributedText.mutableCopy() as? NSMutableAttributedString else {
      return
    }
    // Grab the word.
    guard let word = getWordAt(point: recognizer.location(in: textView), textView: textView) else { return }
    // Animate the word being tapped by highlighting it in red.
    mutableText.addAttribute(.backgroundColor, value: UIColor.red, range: word.range)
    UIView.transition(with: textView, duration: 0.1, options: .transitionCrossDissolve, animations: {
      textView.attributedText = mutableText
    }, completion: { _ in
      UIView.transition(with: textView, duration: 0.3, options: .transitionCrossDissolve, animations: {
        mutableText.removeAttribute(.backgroundColor, range: word.range)
        textView.attributedText = mutableText
      }, completion: nil)
    })

    print(word)
  }

  /// Return the word that was tapped within the textview.
  ///
  /// - Paremeters:
  ///   - point: A position within the tapped UITextView.
  ///   - textView: The textView that was tappped.
  ///   - charIndex:
  func getWordAt(point: CGPoint, textView: UITextView) -> Word? {
    if let textPosition = textView.closestPosition(to: point)
    {
      if let textRange = textView.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: 1)
      {
        let location = textView.offset(from: textView.beginningOfDocument, to: textRange.start)
        let length = textView.offset(from: textRange.start, to: textRange.end)
        guard let wordText = textView.text(in: textRange) else { return nil }
        let wordRange = NSRange(location: location, length: length)
        return Word(text: wordText, range: wordRange)
      }
    }
    return nil
  }
}
