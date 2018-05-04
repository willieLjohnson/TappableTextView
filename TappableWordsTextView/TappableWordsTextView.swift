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

  ///
  @objc func textTapped(recognizer: UITapGestureRecognizer) {
    print("HAPPEN")
    guard let textView = recognizer.view as? UITextView else {
      return
    }
    let layoutManager = textView.layoutManager
    var location = recognizer.location(in: textView)
//    location.x -= textView.textContainerInset.left
//    location.y -= textView.textContainerInset.top

    let charIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

    guard charIndex < textView.textStorage.length else {
      return
    }
    print(getWordAtPosition(location, textView: textView, charIndex: charIndex))
  }

  func getWordAtPosition(_ point: CGPoint, textView: UITextView, charIndex: Int) -> String? {
    if let textPosition = textView.closestPosition(to: point)
    {
      if let range = textView.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: 1)
      {
        guard let mutableText = textView.attributedText.mutableCopy() as? NSMutableAttributedString else {
          return nil
        }
        let location = textView.offset(from: textView.beginningOfDocument, to: range.start)
        let length = textView.offset(from: range.start, to: range.end)
        let nsRange = NSRange(location: location, length: length)
        mutableText.addAttribute(.backgroundColor, value: UIColor.red, range: nsRange)

        UIView.transition(with: textView, duration: 0.2, options: .transitionCrossDissolve, animations: {
          textView.attributedText = mutableText
        }, completion: nil)
        return textView.text(in: range)
      }
    }
    return nil
  }
}
