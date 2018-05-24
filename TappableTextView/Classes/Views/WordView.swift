//
//  WordView.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/17/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

protocol WordViewDelegate: class {
  func closeButtonPressed()
}

@available(iOS 10.0, *)
public class WordView: NibDesignable {
  @IBOutlet private weak var closeButton: UIButton!
  @IBOutlet private weak var wordLabel: UILabel!
  @IBOutlet private weak var wordImageView: UIImageView!
  @IBOutlet private weak var wordTextView: UITextView!
  @IBInspectable public var color: UIColor = .white {
    willSet {
      updateColors()
    }
  }
  @IBInspectable public var wordText: String? {
    willSet {
      wordLabel?.text = wordText
    }
  }

  var word: Word? {
    willSet(word) {
      wordText = word?.text
    }
  }

  let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

  weak var delegate: WordViewDelegate?
  weak var highlightView: HighlightView?
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  convenience init(highlightView: HighlightView) {
    self.init(frame: highlightView.frame)
    self.highlightView = highlightView
    self.word = highlightView.word
    wordLabel.text = word!.text
    highlightView.tapped = true
    color = highlightView.color
    updateColors()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }


  @IBAction func closeButtonPressed(_ sender: Any) {
    guard let delegate = delegate else { return }
    delegate.closeButtonPressed()
    dismissAnimation()
  }
}

// MARK: Animations
@available(iOS 10.0, *)
extension WordView {
  func expandToSuperview() {
    guard let superview = superview else { return }
    guard let word = word else { return }
    // Prepare view
    frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: superview.frame.height).insetBy(dx: 10, dy: 25)
    center = CGPoint(x: word.rect.midX, y: word.rect.midY)
    transform = .init(scaleX: word.rect.width / frame.width, y: word.rect.height / frame.height)
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.25)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    // Corner animation
    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
    cornerAnimation.fromValue = superview.frame.height / 4
    cornerAnimation.toValue = 8
    layer.cornerRadius = 8
    wordImageView.layer.cornerRadius = 8
    layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    wordImageView.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    // Expand animation
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
      self.impactFeedbackGenerator.impactOccurred()
      self.transform = .identity
      self.center = CGPoint(x: superview.bounds.midX, y: superview.bounds.midY)
    })
    CATransaction.commit()
  }

  func dismissAnimation() {
    guard let superview = superview else { return }
    guard let word = word else { return }
    superview.sendSubview(toBack: self)
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.2)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))

    // Layer animations
    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
    cornerAnimation.fromValue = layer.cornerRadius
    cornerAnimation.toValue = frame.height / 2
    layer.cornerRadius = frame.height / 2
    layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
      self.transform = .init(scaleX: word.rect.width / self.frame.width, y: word.rect.height / self.frame.height)
      self.center = CGPoint(x: word.rect.midX, y: word.rect.midY)
    }, completion: ({ _ in
      self.removeFromSuperview()
      guard let highlightView = self.highlightView else { return }
      highlightView.dismissAnimation()
    }))
    CATransaction.commit()
  }
}

// MARK: Helper methods
@available(iOS 10.0, *)
private extension WordView {
  func setupView() {
    clipsToBounds = true
    layer.masksToBounds = false
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 4
    layer.shadowOffset = CGSize(width: 2, height: 2)
    updateColors()
  }

  func updateColors() {
    backgroundColor = color
    wordTextView.backgroundColor = color
    wordTextView.textColor = color.contrastColor()
    wordTextView.tintColor = color.contrastColor()
    wordLabel.textColor = color.contrastColor()
    closeButton.tintColor = color.contrastColor()
    layer.shadowColor = color.contrastColor().cgColor
  }
}
