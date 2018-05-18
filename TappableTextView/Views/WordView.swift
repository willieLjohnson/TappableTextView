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

@IBDesignable
class WordView: UIView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var wordLabel: UILabel!
  let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

  @IBInspectable var color: UIColor? {
    didSet {
      contentView.backgroundColor = color
    }
  }

  weak var delegate: WordViewDelegate?
  var word: Word!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  convenience init(frame: CGRect, word: Word) {
    self.init(frame: frame)
    self.word = word
    wordLabel.text = word.text
  }

  required init?(coder aDecoder: NSCoder) {
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
extension WordView {
  func expandTo(_ view: UIView) {
    guard let superview = superview else { return }
    frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height).insetBy(dx: 10, dy: 10)
    center = CGPoint(x: self.word.rect.midX, y: self.word.rect.midY)
    transform = .init(scaleX: self.word.rect.width / self.frame.width, y: self.word.rect.height / self.frame.height)
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
      self.transform = .identity
      self.center = superview.convert(view.center, from: view)
    })
  }

  func dismissAnimation() {
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
      self.transform = .init(scaleX: self.word.rect.width / self.frame.width, y: self.word.rect.height / self.frame.height)
      self.center = CGPoint(x: self.word.rect.midX, y: self.word.rect.midY)
    }, completion: ({ _ in
      self.removeFromSuperview()
    }))
  }
}

// MARK: Helper methods
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
