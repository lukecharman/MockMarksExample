import Foundation

extension MockMarks {

  /// Used to load stubs from JSON files stored in the app bundle, and decode them.
  struct Loader {

    /// Looks for a JSON file with the given name, and decodes its contents into an array of mocked responses.
    ///
    /// - Parameters:
    ///   - name: The filename to look for in the app bundle which contains ordered, stubbed responses.
    ///   - bundle: The bundle in which to look for JSON stubs. Defaults to the app's main bundle.
    ///
    /// - Returns: An optional array of `MockMarksMockedResponse`s, read sequentially from the named JSON.
    func loadJSON(named name: String, in bundle: Bundle = .main) -> [MockMark]? {
      guard let data = loadJSONData(named: name, in: bundle) else {
        return nil
      }

      guard let json = loadJSON(from: data) else {
        return nil
      }

      return parseStubs(from: json)
    }

    /// Load JSON data from the given bundle of the given name.
    ///
    /// - Parameters:
    ///   - name: The filename to look for in the app bundle which contains ordered, stubbed responses.
    ///   - bundle: The bundle in which to look for JSON stubs. Defaults to the app's main bundle.
    ///
    /// - Returns: An optional instance of `Data` containing the contents of the named file.
    func loadJSONData(named name: String, in bundle: Bundle = .main) -> Data? {
      guard let bundleURL = bundle.url(forResource: name, withExtension: "json") else {
        return nil
      }

      return try? Data(contentsOf: bundleURL)
    }

    /// Load JSON data structure from the given `Data` object.
    ///
    /// - Parameters:
    ///   - data: The data to be converted to JSON.
    ///
    /// - Returns: An optional array of JSON dictionaries, each representing a stub, read sequentially from the named JSON.
    func loadJSON(from data: Data) -> [[AnyHashable: Any]]? {
      try? JSONSerialization.jsonObject(with: data) as? [[AnyHashable: Any]]
    }

    /// Parse stub JSON into `MockMark` objects.
    ///
    /// - Parameters:
    ///   - json: The JSON to be read and parsed.
    ///
    /// - Returns: An array of `MockMark`s, each representing a stub.
    func parseStubs(from json: [[AnyHashable: Any]]) -> [MockMark] {
      var stubs = [MockMark]()

      for i in 0..<json.count {
        guard let string = json[i]["url"] as? String else {
          continue
        }

        guard let url = URL(string: string) else {
          continue
        }

        guard let response = json[i]["mock"] as? [AnyHashable: Any] else {
          continue
        }

        let mockMarkResponse = MockMark.Response(
          data: try! JSONSerialization.data(withJSONObject: response["json"]!),
          urlResponse: HTTPURLResponse(
            url: url,
            statusCode: response["statusCode"] as? Int ?? 200,
            httpVersion: nil,
            headerFields: nil
          ),
          error: nil
        )

        stubs.append(MockMark(url: url, response: mockMarkResponse))
      }

      return stubs
    }
  }
}
