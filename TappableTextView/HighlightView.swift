//
//  HighlightView.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/15/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

class HighlightView: UIView {
  @IBOutlet var contentView: UILabel!
  var word: Word!
  var tapped: Bool = false

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  convenience init(word: Word) {
    self.init(frame: word.rect)
    self.word = word
    setupView()
    contentView.text = word.text
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
}

// MARK: - Helper methods
private extension HighlightView {
  /// Configure the UITextView with the required gestures to make text in the view tappable.
  func setupView() {
//    backgroundColor = .white
    clipsToBounds = false
    layer.cornerRadius = frame.height / 4
    layer.shadowOpacity = 0.5
    let randomHue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    layer.shadowColor = UIColor(hue: randomHue, saturation: 0.6, brightness: 0.6, alpha: 1).cgColor
    layer.shadowRadius = 2
    layer.shadowOffset = CGSize(width: 0, height: 2)
    backgroundColor = UIColor(hue: randomHue, saturation: 0.6, brightness: 0.9, alpha: 1)

    contentView = loadNib(viewType: UILabel.self)
    contentView.backgroundColor = .clear
    addSubview(contentView)
    contentView.constrain(to: self)
    contentView.textColor = UIColor(hue: randomHue, saturation: 0.9, brightness: 0.3, alpha: 1)
  }

  /// Handle taps on the contentView.
  ///
  /// - Parameter recognizer: The UITapGestureRecognizer that triggered this handler.
  @objc func handleTap(recognizer: UITapGestureRecognizer) {
    print("TAP")
    tapped = true
  }
}
