//
//  WordImage.swift
//  TappableTextView
//
//  Created by Willie Johnson on 8/8/21.
//

import Foundation

struct Images: Decodable {
  let totalCount: Int
  let value: [Image]
}

struct Image: Decodable {
  let url: String
}


let headers = [
  "x-rapidapi-key": "751fb2e1d1msh2b6b56caaaa5e1ep10695fjsn2a76ed4063e0",
  "x-rapidapi-host": "contextualwebsearch-websearch-v1.p.rapidapi.com"
]

let imagesCache = NSCache<AnyObject, AnyObject>()


extension Word {
  func getWordImageURL(success: @escaping (String) -> ()) {
    if let imagesFromCache = imagesCache.object(forKey: self.getText() as AnyObject) as? Images {
      guard let random = imagesFromCache.value.randomElement() else { return }
      success(random.url)
      return
    }

    let request = NSMutableURLRequest(url: NSURL(string: "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI?q=\(self.getText())&pageNumber=1&pageSize=10&autoCorrect=true")! as URL,
                                      cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      if let error = error {
        print(error)
        return
      }

      guard let httpResponse = response as? HTTPURLResponse else { return }
      print(httpResponse)

      if let data = data {
        if let result = try? JSONDecoder().decode(Images.self, from: data) {
          imagesCache.setObject(result as AnyObject, forKey: self.getText() as AnyObject)
          guard let random = result.value.randomElement() else { return }
          success(random.url)
        } else {
          print("Invalid Response \(String(data: data, encoding: String.Encoding.utf8) as String?)")
        }
      } else if let error = error {
        print("HTTP Request Failed \(error)")
      }
    })

    dataTask.resume()

  }
}
