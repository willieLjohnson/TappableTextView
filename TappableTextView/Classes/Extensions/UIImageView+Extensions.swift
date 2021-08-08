//
//  UIImageView+Extensions.swift
//  TappableTextView
//
//  Created by Willie Johnson on 8/8/21.
//

import Foundation

let imageCache = NSCache<AnyObject, AnyObject>()

public extension UIImage {
  func fromURL(_ url: URL, completion: @escaping (UIImage?) -> ())  {
    self.getImage(from: url) { result in
      completion(result)
    }
  }

  private func getImage(from url: URL, _ completion: @escaping (UIImage?) -> ()) {
    if let imageFromCache = imageCache.object(forKey: url as AnyObject) {
      completion(imageFromCache as? UIImage)
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let imageToCache = UIImage(data: data)
      else { return }

      imageCache.setObject(imageToCache, forKey: url as AnyObject)
      completion(imageToCache)
    }.resume()
  }
}

