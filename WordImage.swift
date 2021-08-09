//
//  WordImage.swift
//  TappableTextView
//
//  Created by Willie Johnson on 8/8/21.
//

import Foundation

public struct Images: Decodable {
  let totalCount: Int
  let value: [Image]
}

public struct Image: Decodable {
  let url: String
}


let headers = [
  "x-rapidapi-key": "751fb2e1d1msh2b6b56caaaa5e1ep10695fjsn2a76ed4063e0",
  "x-rapidapi-host": "contextualwebsearch-websearch-v1.p.rapidapi.com"
]

let imagesCache = NSCache<AnyObject, AnyObject>()


extension Word {
  func getWordImages(completion: @escaping ImagesResult) {
    let urlString = "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI?q=\(self.getText())&pageNumber=0&pageSize=20&autoCorrect=true&safeSearch=true"
    if let imagesFromCache = imagesCache.object(forKey: urlString as AnyObject) as? Images {
      completion(.success(imagesFromCache))
      return
    }

    let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
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
        completion(.failure("error"))
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
