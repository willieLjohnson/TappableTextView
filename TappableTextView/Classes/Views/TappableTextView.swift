//
//  TappableTextView.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/4/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

public protocol TappableTextViewDelegate: AnyObject {
  func wordViewUpdated(_ wordView: WordView)
  func wordViewOpened(_ wordView: WordView)
  func wordViewClosed(_ wordView: WordView)
}

@available(iOS 10.0, *)
@IBDesignable
open class TappableTextView: NibDesignable {
  @IBOutlet private weak var contentView: UITextView!

  @IBInspectable public var color: UIColor = .black {
    willSet(color) {
      updateViews()
    }
  }
  @IBInspectable public var text: String? {
    willSet {
      self.contentView?.text = text
    }
  }

  /// Handles behaviors for the **contentView**.
  private var animator: UIDynamicAnimator!
  /// The behavior that forces the **wordView** to remain in the center of the **contentView**.
  private var snap: UISnapBehavior!
  /// The impactFeeddbackGenerator that's tied to the **contentView's** tap gesture.
  private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)


  /// The subview that appears when a highlighted word (HighlightView) is pressed.
  public var wordView: WordView?

  weak var delegate: TappableTextViewDelegate?

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  public convenience init(frame: CGRect, color: UIColor) {
    self.init(frame: frame)
    self.color = color
    updateViews()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  public func setDelegate(_ delegate: TappableTextViewDelegate) {
    self.delegate = delegate
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
    contentView.contentInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)

    let textTapGesture = UITapGestureRecognizer(target: self, action: #selector(textTapped(recognizer:)))
    textTapGesture.numberOfTapsRequired = 1
    contentView.addGestureRecognizer(textTapGesture)

    animator = UIDynamicAnimator(referenceView: contentView)
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
    guard let textRange = textView.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: convertToUITextDirection(1)) else { return nil }
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
    snap = UISnapBehavior(item: wordView, snapTo: CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY))
    snap.damping = 0.9
    animator.addBehavior(snap)
    guard let delegate = delegate else { return }
    delegate.wordViewOpened(wordView)
  }

  @objc func handleSwipeOnWordView(recognizer: UIPanGestureRecognizer) {
    guard let contentView = contentView else { return }
    guard let wordView = recognizer.view as? WordView else { return }
    guard let wordViewTextView = wordView.superview as? UITextView else { return }
    contentView.bringSubviewToFront(wordView)
    let translation = recognizer.translation(in: wordViewTextView)
    wordView.center = CGPoint(x: wordView.center.x + translation.x, y: wordView.center.y + translation.y)
    recognizer.setTranslation(CGPoint.zero, in: wordViewTextView)
    switch recognizer.state {
    case .began:
      animator.removeBehavior(snap)
    case .ended, .cancelled, .failed:
      let velocity = recognizer.velocity(in: wordViewTextView)
      let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
      guard magnitude < 700 else {
        wordView.closeButtonPressed(self)
        return
      }
      self.animator.addBehavior(self.snap)
    default: break
    }
  }
}

@available(iOS 10.0, *)
extension TappableTextView: WordViewDelegate {
  func wordViewUpdated(_ wordView: WordView) {
    guard let delegate = delegate else { return }
    delegate.wordViewUpdated(wordView)

  }

  func closeButtonPressed() {
    self.animator.removeAllBehaviors()

    guard let delegate = delegate else { return }
    guard let wordView = wordView else { return }
    delegate.wordViewClosed(wordView)
    self.wordView = nil
  }
}

@available(iOS 10.0, *)
extension TappableTextView: UIGestureRecognizerDelegate {
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUITextDirection(_ input: Int) -> UITextDirection {
	return UITextDirection(rawValue: input)
}
