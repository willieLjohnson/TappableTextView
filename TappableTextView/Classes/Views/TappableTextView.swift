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

open class TappableTextView: UITextView {
  public var color: UIColor = .black {
    willSet(color) {
      updateViews()
    }
  }

  /// Handles behaviors for the **contentView**.
  private var animator: UIDynamicAnimator!
  /// The behavior that forces the **wordView** to remain in the center of the **contentView**.
  private var snap: UISnapBehavior!
  /// The subview that appears when a highlighted word (HighlightView) is pressed.
  public var wordView: WordView?

  weak var tappableTextViewDelegate: TappableTextViewDelegate?

  public weak var rootTappableTextView: TappableTextView?

  public override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setupView()
  }

  public convenience init(frame: CGRect, color: UIColor) {
    self.init(frame: frame, textContainer: nil)
    self.color = color
    updateViews()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  public func setDelegate(_ delegate: TappableTextViewDelegate) {
    self.tappableTextViewDelegate = delegate
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
    contentInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)

    let textTapGesture = UITapGestureRecognizer(target: self, action: #selector(textTapped(recognizer:)))
    textTapGesture.numberOfTapsRequired = 1
    addGestureRecognizer(textTapGesture)

    isSelectable = false
    isEditable = false
  }

  func updateViews() {
    backgroundColor = color
    backgroundColor = color
    textColor = color.contrastColor()
    font = Style.normalFont.withSize(20)
  }

  func getRootTappableTextView() -> TappableTextView? {
    if rootTappableTextView == nil {
      rootTappableTextView = self
    }

    return rootTappableTextView
  }
  /// Handle taps on the UITextView.
  ///
  /// - Parameter recognizer: The UITapGestureRecognizer that triggered this handler.
  @objc func textTapped(recognizer: UITapGestureRecognizer) {
    guard wordView == nil else { return }
    Global.softImpactFeedbackGenerator.prepare()
    // Grab UITextView and its content.
    guard let textView = recognizer.view as? UITextView else {
      return
    }
    // Grab the word.
    let tapLocation = recognizer.location(in: textView)
    guard let word = getWordAt(point: tapLocation) else { return }
    let highlight = HighlightView(word: word, color: .randomColor())
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnHighlightView(recognizer:)))
    tapGesture.delegate = self
    textView.addSubview(highlight)
    highlight.addGestureRecognizer(tapGesture)
    // Animate highlight
    highlight.transform = .init(scaleX: 0.01, y: 1)
    highlight.expandAnimation()
    Global.softImpactFeedbackGenerator.impactOccurred()
    textView.selectedTextRange = nil
  }
  

  
  @objc func handleTapOnHighlightView(recognizer: UIGestureRecognizer) {
    guard let highlightView = recognizer.view as? HighlightView else { return }
    if let wordView = wordView {
      wordView.closeButtonPressed(getRootTappableTextView()!)
    }
    wordView = WordView(highlightView: highlightView)
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeOnWordView(recognizer:)))
    panGesture.delegate = self
    guard let wordView = wordView else { return }
    wordView.addGestureRecognizer(panGesture)
    wordView.delegate = self
    guard let rootTappableTextView = getRootTappableTextView() else { return }
    wordView.rootTappableTextView = rootTappableTextView
    rootTappableTextView.addSubview(wordView)
    wordView.openAnimation()
    animator = UIDynamicAnimator(referenceView: rootTappableTextView)
    snap = UISnapBehavior(item: wordView, snapTo: CGPoint(x: rootTappableTextView.bounds.midX, y: rootTappableTextView.bounds.midY))
    snap.damping = 0.9
    animator.addBehavior(snap)
    guard let tappableTextViewDelegate = rootTappableTextView.tappableTextViewDelegate else { return }
    tappableTextViewDelegate.wordViewOpened(wordView)
  }

  @objc func handleSwipeOnWordView(recognizer: UIPanGestureRecognizer) {
    guard let wordView = recognizer.view as? WordView else { return }
    guard let wordViewTextView = wordView.superview as? UITextView else { return }
    bringSubviewToFront(wordView)
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
    guard let tappableTextViewDelegate = tappableTextViewDelegate else { return }
    tappableTextViewDelegate.wordViewUpdated(wordView)
  }

  func closeButtonPressed() {
    self.animator.removeAllBehaviors()

    guard let tappableTextViewDelegate = tappableTextViewDelegate else { return }
    guard let wordView = wordView else { return }
    tappableTextViewDelegate.wordViewClosed(wordView)
    self.wordView = nil
  }
}

@available(iOS 10.0, *)
extension TappableTextView: UIGestureRecognizerDelegate {
}
