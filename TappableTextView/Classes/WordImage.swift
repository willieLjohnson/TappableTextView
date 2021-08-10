//
//  WordImage.swift
//  TappableTextView
//
//  Created by Willie Johnson on 8/8/21.
//

import Foundation

let baseAPIURL = "https://api.unsplash.com/search/photos?query="
public struct Images: Decodable {
  let total: Int
  let total_pages: Int
  let results: [Image]
}

public struct Image: Decodable {
  let id: String
  let width: Int
  let height: Int
  let urls: ImageURLS

  public init() {
    self.id = ""
    self.width = 0
    self.height = 0
    self.urls = ImageURLS()
  }
}

public struct ImageURLS: Decodable {
  let raw: String
  let full: String
  let regular: String
  let small: String
  let thumb: String

  public init() {
    self.raw = ""
    self.full = ""
    self.regular = ""
    self.small = ""
    self.thumb = ""
  }
}




let headers = [
  "Authorization": "Client-ID \(Constants.unsplashAPIKey)",
]

let imagesCache = NSCache<AnyObject, AnyObject>()


extension Word {
  func getWordImages(completion: @escaping ImagesResult) {
    let urlString = baseAPIURL + "\(self.getText())"
    guard let url = NSURL(string: urlString) as URL? else {
      completion(.failure("Invalid URL"))
      return
    }
    if let imagesFromCache = imagesCache.object(forKey: urlString as AnyObject) as? Images {
      completion(.success(imagesFromCache))
      return
    }

    let request = NSMutableURLRequest(url: url,
                                      cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      if let error = error {
        completion(.failure(error))
        return
      }

      guard (response as? HTTPURLResponse) != nil else {
        completion(.failure("response error: \(String(describing: response))"))
        return

      }

      if let data = data {
        if let result = try? JSONDecoder().decode(Images.self, from: data) {
          imagesCache.setObject(result as AnyObject, forKey: urlString as AnyObject)
          completion(.success(result))
        } else {
          completion(.failure("Invalid Response \(String(data: data, encoding: String.Encoding.utf8) as String?)"))
        }
      } else if let error = error {
        completion(.failure(error))
      }
    })

    dataTask.resume()

  }
}
