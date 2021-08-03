//
//  HighlightView.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/15/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
@IBDesignable
public class HighlightView: NibDesignable {
  @IBOutlet weak var textLabel: UILabel!
  @IBInspectable public var color: UIColor = .black {
    willSet(color) {
      updateViews()
    }
  }
  @IBInspectable public var text: String? {
    willSet(text) {
      self.textLabel?.text = text
    }
  }
  var word: Word? {
    willSet(word) {
      self.text = word?.text
    }
  }
  var tapped: Bool = false

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  convenience init(word: Word, color: UIColor) {
    self.init(frame: word.rect)
    self.word = word
    self.color = color
    updateViews()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
}

// MARK: - Animations
@available(iOS 10.0, *)
extension HighlightView {
  func expandAnimation() {
    guard let word = word else { return }
    /* Do Animations */
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.2)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))

    // View animations
    frame = CGRect(x: 0, y: 0, width: frame.width * 1.1, height: frame.height)
    center = CGPoint(x: word.rect.midX, y: word.rect.midY)
    transform = .init(scaleX: 0.01, y: 1)
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
      self.transform = .identity
    }, completion: { _ in
      let queue = OperationQueue()
      let autoDismiss = BlockOperation {
        sleep(2)
        DispatchQueue.main.async {
          guard self.tapped == false else { return }
          self.dismissAnimation()
        }
      }
      queue.addOperation(autoDismiss)
    })

    // Layer animations
    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
    cornerAnimation.fromValue = 0
    cornerAnimation.toValue = frame.height / 4
    layer.cornerRadius = frame.height / 4
    layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))

    CATransaction.commit()
  }

  func dismissAnimation() {
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
      self.transform = .init(scaleX: 1.1, y: 0.01)
    }, completion: ({ _ in
      self.removeFromSuperview()
    }))
  }
}

// MARK: - Helper methods
@available(iOS 10.0, *)
private extension HighlightView {
  /// Configure the UITextView with the required gestures to make text in the view tappable.
  func setupView() {
    layer.cornerRadius = frame.height / 4
    updateViews()
  }

  func updateViews() {
    guard let textLabel = textLabel else { return }
    backgroundColor = color
    textLabel.textColor = color.contrastColor()
    textLabel.tintColor = color.contrastColor()
    text = word?.text
  }
}
