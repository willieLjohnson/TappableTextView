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

  func loadImage(fromURL urlString: String, completion: @escaping VoidResult) {
    guard let url = URL(string: urlString) else {
      completion(.failure("Not a valid URL"))
      return
    }

    UIImage().fromURL(url) { imageResult in
      DispatchQueue.main.async { [self] in
        switch imageResult {
        case let .success(image):
          self.image = image
          completion(.success)
        case .failure:
          completion(.failure("error"))
        }
      }
    }
  }
}
