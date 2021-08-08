//
//  UIImageView+Extensiosn.swift
//  TappableTextView
//
//  Created by Willie Johnson on 8/8/21.
//

import Foundation

extension UIImageView {

  func withImage(_ image: UIImage, contentMode mode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
    contentMode = mode
    self.image = image
    return self
  }
}
