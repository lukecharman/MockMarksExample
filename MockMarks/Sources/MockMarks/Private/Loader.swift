import Foundation

extension MockMarks {

  /// Simple typealiases used to make this structure cleaner to read.
  private typealias MockMarkDictionary = [String: Any]
  private typealias MockMarkArray = [MockMarkDictionary]

  /// Used to load mocks from JSON files, and decode them.
  struct Loader {

    struct Constants {
      static let url = "url"
      static let mock = "mock"
      static let json = "json"
      static let error = "error"
      static let statusCode = "statusCode"
    }

    /// Looks for a JSON file at the given URL, and decodes its contents into an array of mocked responses.
    ///
    /// - Parameters:
    ///   - url: The location at which to look for a JSON file containing ordered, mocked responses.
    ///
    /// - Returns: An optional array of `MockMark`s, read sequentially from the named JSON.
    func loadJSON(from url: URL) -> [MockMark]? {
      guard let data = try? Data(contentsOf: url) else { return nil }
      guard let json = try? JSONSerialization.jsonObject(with: data) as? MockMarkArray else { return nil }

      var mocks = [MockMark]()

      for dict in json {
        guard let urlString = dict[Constants.url] as? String else { continue }
        guard let url = URL(string: urlString) else { continue }
        guard let mock = dict[Constants.mock] as? MockMarkDictionary else { continue }

        var jsonData: Data?
        if let jsonObject = mock[Constants.json] {
          jsonData = try? JSONSerialization.data(withJSONObject: jsonObject)
        }

        mocks.append(
          MockMark(
            url: url,
            response: MockMark.Response(
              data: jsonData,
              urlResponse: HTTPURLResponse(
                url: url,
                statusCode: mock[Constants.statusCode] as? Int ?? 200,
                httpVersion: nil,
                headerFields: nil
              ),
              error: nil
            )
          )
        )
      }

      return mocks
    }
  }
}
