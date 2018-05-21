//
//  TappableTextView.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/4/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
@IBDesignable
open class TappableTextView: NibDesignable {
  @IBOutlet private weak var contentView: UITextView!
  @IBInspectable public var color: UIColor = .white {
    willSet(color) {
      updateViews()
    }
  }
  @IBInspectable public var text: String? {
    willSet {
      self.contentView?.text = text
    }
  }
  
  let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
  var wordView: WordView?

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  public convenience init(frame: CGRect, color: UIColor) {
    self.init(frame: frame)
    self.color = color
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
}

@available(iOS 10.0, *)
extension TappableTextView: UITextViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let wordView = wordView else { return }
    let distance = abs(wordView.frame.origin.y - scrollView.contentOffset.y)
    guard distance > 80 else { return }
    wordView.closeButtonPressed(self)
  }
}

// MARK: - Helper methods
@available(iOS 10.0, *)
private extension TappableTextView {
  /// Configure the UITextView with the required gestures to make text in the view tappable.
  func setupView() {
    guard let contentView = contentView else { return }
    contentView.delegate = self
    contentView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16)
    let textTapGesture = UITapGestureRecognizer(target: self, action: #selector(textTapped(recognizer:)))
    textTapGesture.numberOfTapsRequired = 1
    contentView.addGestureRecognizer(textTapGesture)
  }

  func updateViews() {
    guard let contentView = contentView else { return }
    backgroundColor = color
    contentView.backgroundColor = color
    contentView.textColor = color.contrastColor()
  }

  /// Handle taps on the UITextView.
  ///
  /// - Parameter recognizer: The UITapGestureRecognizer that triggered this handler.
  @objc func textTapped(recognizer: UITapGestureRecognizer) {
    guard wordView == nil else { return }
    impactFeedbackGenerator.prepare()
    // Grab UITextView and its content.
    guard let textView = recognizer.view as? UITextView else {
      return
    }
    // Grab the word.
    let tapLocation = recognizer.location(in: textView)
    guard let word = self.getWordAt(point: tapLocation, textView: textView) else { return }
    let highlight = HighlightView(word: word, color:  .randomColor())
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnHighlightView(recognizer:)))
    tapGesture.delegate = self
    textView.addSubview(highlight)
    highlight.addGestureRecognizer(tapGesture)
    // Animate highlight
    highlight.transform = .init(scaleX: 0.01, y: 1)
    highlight.expandAnimation()
    impactFeedbackGenerator.impactOccurred()
    textView.selectedTextRange = nil
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
  
  @objc func handleTapOnHighlightView(recognizer: UIGestureRecognizer) {
    guard let contentView = contentView else { return }
    guard let highlightView = recognizer.view as? HighlightView else { return }
    if let wordView = wordView {
      wordView.closeButtonPressed(self)
    }
    wordView = WordView(highlightView: highlightView)
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeOnWordView(recognizer:)))
    panGesture.delegate = self
    guard let wordView = wordView else { return }
    wordView.addGestureRecognizer(panGesture)
    wordView.delegate = self
    contentView.addSubview(wordView)
    wordView.expandToSuperview()
  }

  @objc func handleSwipeOnWordView(recognizer: UIPanGestureRecognizer) {
    guard let contentView = contentView else { return }
    guard let wordView = recognizer.view as? WordView else { return }
    guard let wordViewTextView = wordView.superview as? UITextView else { return }
    contentView.bringSubview(toFront: wordView)
    let translation = recognizer.translation(in: wordViewTextView)
    wordView.center = CGPoint(x: wordView.center.x + translation.x, y: wordView.center.y + translation.y)
    recognizer.setTranslation(CGPoint.zero, in: wordViewTextView)
    switch recognizer.state {
    case .began:
      wordView.layer.removeAllAnimations()
    case .ended:
      let velocity = recognizer.velocity(in: wordViewTextView)
      let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
      guard magnitude < 700 else {
        wordView.closeButtonPressed(self)
        return
      }
      let slideMultiplier = magnitude / 400
      
      let slideFactor = 0.1 * slideMultiplier

      let finalPoint = CGPoint(x: wordView.center.x + (velocity.x * slideFactor),
                               y: wordView.center.y + (velocity.y * slideFactor))

      UIView.animate(withDuration: Double(slideFactor * 2), delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
        wordView.center = finalPoint
      })
    default: break
    }
  }
}

@available(iOS 10.0, *)
extension TappableTextView: WordViewDelegate {
  func closeButtonPressed() {
    wordView = nil
  }
}

@available(iOS 10.0, *)
extension TappableTextView: UIGestureRecognizerDelegate {
}
