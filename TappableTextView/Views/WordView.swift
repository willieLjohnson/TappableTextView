//
//  WordView.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/17/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

class WordView: UIView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var closeButton: UIButton!

  var word: Word!
  @IBOutlet weak var wordLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  convenience init(frame: CGRect, word: Word) {
    self.init(frame: frame)
    self.word = word
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  @IBAction func dismissView(_ sender: Any) {
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
      self.frame = self.word.rect
    }, completion: ({ _ in
      self.removeFromSuperview()
    }))
  }
}

// MARK: Helper methods
private extension WordView {
  func setupView() {
    contentView = loadNib(viewType: UIView.self)
    addSubview(contentView)
    contentView.constrain(to: self)
    contentView.backgroundColor = .clear

//    clipsToBounds = false
    layer.cornerRadius = 10
//    layer.shadowOpacity = 0.5
//    layer.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0.6, alpha: 1).cgColor
//    layer.shadowRadius = 2
//    layer.shadowOffset = CGSize(width: 4, height: 4)
  }
}
