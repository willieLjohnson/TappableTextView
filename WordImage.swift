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


extension Word {
  func getWordImageURL(success: @escaping (String) -> ()) {
    print("getting image")
    let request = NSMutableURLRequest(url: NSURL(string: "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI?q=\(self.getText())&pageNumber=1&pageSize=10&autoCorrect=true")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
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
          guard let first = result.value.first else { return }
          success(first.url)
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
