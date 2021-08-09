//
//  UIImageView+Extensions.swift
//  TappableTextView
//
//  Created by Willie Johnson on 8/8/21.
//

import Foundation

let imageCache = NSCache<AnyObject, AnyObject>()

public extension UIImage {
  func fromURL(_ url: URL, completion: @escaping UIImageResult)  {
    self.getImage(from: url) { imageResult in
      switch imageResult {
      case let .success(image):
        completion(.success(image))
      case .failure:
        completion(.failure("Image not found"))
      }
    }
  }

  private func getImage(from url: URL, _ completion: @escaping UIImageResult) {
    if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
      completion(.success(imageFromCache))
      return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let imageToCache = UIImage(data: data)
      else {
        completion(.failure("error"))
        return
      }

      imageCache.setObject(imageToCache, forKey: url as AnyObject)
      completion(.success(imageToCache))
    }.resume()
  }
}

