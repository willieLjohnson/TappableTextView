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
@IBDesignable
public class WordView: UIView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var wordLabel: UILabel!
  @IBOutlet weak var wordImage: UIImageView!
  @IBOutlet weak var wordText: TappableTextView!
  
  let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
  public var color: UIColor = .white {
    didSet {
      updateColors()
    }
  }
  weak var delegate: WordViewDelegate?
  weak var highlightView: HighlightView?
  var word: Word!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  convenience init(highlightView: HighlightView) {
    self.init(frame: highlightView.frame)
    self.highlightView = highlightView
    highlightView.tapped = true
    self.word = highlightView.word
    wordLabel.text = word.text
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
    // Prepare view
    frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: superview.frame.height).insetBy(dx: 10, dy: 25)
    center = CGPoint(x: self.word.rect.midX, y: self.word.rect.midY)
    transform = .init(scaleX: self.word.rect.width / self.frame.width, y: self.word.rect.height / self.frame.height)
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.25)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    // Corner animation
    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
    cornerAnimation.fromValue = superview.frame.height / 4
    cornerAnimation.toValue = 8
    layer.cornerRadius = 8
    wordImage.layer.cornerRadius = 8
    layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    wordImage.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    // Expand animation
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
      self.impactFeedbackGenerator.impactOccurred()
      self.transform = .identity
      self.center = CGPoint(x: superview.bounds.midX, y: superview.bounds.midY)
    })
    CATransaction.commit()
  }

  func dismissAnimation() {
    guard let superview = superview else { return }
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
      self.transform = .init(scaleX: self.word.rect.width / self.frame.width, y: self.word.rect.height / self.frame.height)
      self.center = CGPoint(x: self.word.rect.midX, y: self.word.rect.midY)
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
    contentView = loadNib(viewType: UIView.self)
    addSubview(contentView)
    contentView.constrain(to: self)
    updateColors()
    clipsToBounds = true
    layer.masksToBounds = false
    layer.shadowOpacity = 0.5
    layer.shadowColor = color.contrastColor().cgColor
    layer.shadowRadius = 4
    layer.shadowOffset = CGSize(width: 2, height: 2)
  }

  func updateColors() {
    backgroundColor = color
    wordText.color = color
    wordText.backgroundColor = .clear
    wordLabel.textColor = color.contrastColor()
    closeButton.tintColor = color.contrastColor()
  }
}
