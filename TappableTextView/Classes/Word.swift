//
//  Word.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/10/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import UIKit

public enum DictionaryAPI: String {
  case baseURL = "https://api.dictionaryapi.dev/api/v2/entries/en_US/"
}

public struct Word {
  var text: String
  var range: NSRange
  var rect: CGRect

  public func getText() -> String {
    return text;
  }
}

public struct WordMeaning {
  let partOfSpeech: String
  var definitions: [WordDefinition]

  public init() {
    self.partOfSpeech = ""
    self.definitions = [WordDefinition]()
  }

  public init(decodable: MeaningDecodable) {
    self.partOfSpeech = decodable.partOfSpeech
    self.definitions = [WordDefinition]()

    for decodedDefinition in decodable.definitions {
      self.definitions.append(WordDefinition(definition: decodedDefinition.definition, synonyms: decodedDefinition.synonyms, example: decodedDefinition.example))
    }
  }
  
  public func getPartOfSpeech() -> String {
    return partOfSpeech
  }
  public func getDefintions() -> [WordDefinition] {
    return definitions
  }
}

public struct WordDefinition {
  let definition: String
  let synonyms: [String]?
  let example: String?


  public func getDefinition() -> String {
    return definition
  }
  public func getSynonyms() -> [String]? {
    return synonyms
  }
  public func getExample() -> String? {
    return example
  }
}


struct WordDecodable: Decodable {
  let word: String
  let meanings: [MeaningDecodable]
}

public struct MeaningDecodable: Decodable {
  let partOfSpeech: String
  let definitions: [DefinitionDecodable]
}

public struct DefinitionDecodable: Decodable {
  let definition: String
  let synonyms: [String]?
  let example: String?
}

extension Word {
  public func getWordMeaning(word: Word, completion: @escaping ([MeaningDecodable]) -> Void) {
    guard let url = URL(string: DictionaryAPI.baseURL.rawValue + word.getText()) else { return }
    print(url)
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: request) {data, response, error in
      if let data = data {
        if let result = try? JSONDecoder().decode([WordDecodable].self, from: data) {
          guard let resultWord = result.first else { return }
          completion(resultWord.meanings)
        } else {
          print("Invalid Response \(String(data: data, encoding: String.Encoding.utf8) as String?)")
        }
      } else if let error = error {
        print("HTTP Request Failed \(error)")
      }
    }
    task.resume()
  }

}
