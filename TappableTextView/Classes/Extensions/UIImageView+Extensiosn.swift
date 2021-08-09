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

  func loadImage(fromURL urlString: String, completion: @escaping () -> ()) {
    guard let url = URL(string: urlString) else {
      return
    }

    UIImage().fromURL(url) { image in
      DispatchQueue.main.async {
        completion()
        self.image = image
      }
    }
  }
}
