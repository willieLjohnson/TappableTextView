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
  let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)

  @IBInspectable var color: UIColor? {
    didSet {
      contentView.backgroundColor = color
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
  func expandTo(_ view: UIView) {
    guard let superview = superview else { return }
    frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height).insetBy(dx: 10, dy: 25)
    center = CGPoint(x: self.word.rect.midX, y: self.word.rect.midY)
    transform = .init(scaleX: self.word.rect.width / self.frame.width, y: self.word.rect.height / self.frame.height)
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
      self.impactFeedbackGenerator.impactOccurred()
      self.transform = .identity
      self.center = superview.convert(view.center, from: view)
    })
  }

  func dismissAnimation() {
    guard let superview = superview else { return }
    superview.sendSubview(toBack: self)
    /* Do Animations */
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.2)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))

    // Layer animations
    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
    cornerAnimation.fromValue = 0
    cornerAnimation.toValue = frame.height / 4

    contentView.layer.cornerRadius = frame.height / 2
    contentView.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))

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
    backgroundColor = .clear
    contentView = loadNib(viewType: UIView.self)
    addSubview(contentView)
    contentView.constrain(to: self)
//    clipsToBounds = false
    contentView.layer.cornerRadius = 5
    contentView.layer.shadowOpacity = 0.5
    contentView.layer.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0.6, alpha: 1).cgColor
    contentView.layer.shadowRadius = 4
    contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
  }
}
