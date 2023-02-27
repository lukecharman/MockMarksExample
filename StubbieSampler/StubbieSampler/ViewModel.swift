import Foundation

enum ViewModelError: Error {
  case generic

  var localizedDescription: String {
    "Generic"
  }
}

class ViewModel {

  private let urlSession: URLSession

  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }

  func fetchRandomWord(completion: @escaping (Result<String, Error>) -> Void) {
    let request = URLRequest(url: URL(string: "https://random-word-api.herokuapp.com/word")!)

    urlSession.dataTask(with: request) { data, response, error in
      guard let data, let json = try? JSONSerialization.jsonObject(with: data) as? [String] else {
        return completion(.failure(ViewModelError.generic))
      }

      guard let newString = json.first else {
        return completion(.failure(ViewModelError.generic))
      }

      completion(.success(newString))
    }.resume()
  }

  func fetchLanguageCount(completion: @escaping (Result<Int, Error>) -> Void) {
    let request = URLRequest(url: URL(string: "https://random-word-api.herokuapp.com/languages")!)

    urlSession.dataTask(with: request) { data, response, error in
      guard let data, let json = try? JSONSerialization.jsonObject(with: data) as? [String] else {
        return completion(.failure(ViewModelError.generic))
      }

      completion(.success(json.count))
    }.resume()
  }
}
