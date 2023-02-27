import Foundation

/// Used to load stubs from JSON files stored in the app bundle, and decode them.
struct StubbieLoader {

  /// A data structure representing a mocked response to a specific URL.
  struct Response {
    /// The URL to which queries will return the associated stub.
    let url: URL
    /// The stubbed data which calls to the other URL
    let stub: Any
  }

  /// Looks for a JSON file with the given name, and decodes its contents into an array of mocked responses.
  ///
  /// - Parameters:
  ///   - name: The filename to look for in the app bundle which contains ordered, stubbed responses.
  ///   - bundle: The bundle in which to look for JSON stubs. Defaults to the app's main bundle.
  ///
  /// - Returns: An optional array of `StubbieMockedResponse`s, read sequentially from the named JSON.
  ///
  static func loadJSON(named name: String, in bundle: Bundle = .main) -> [Response]? {
    guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "json") else { return nil }
    guard let data = try? Data(contentsOf: bundleURL) else { return nil }
    guard let json = try? JSONSerialization.jsonObject(with: data) as? [[AnyHashable: Any]] else { return nil }

    var stubs = [Response]()

    for i in 0..<json.count {
      if let string = json[i]["url"] as? String, let stub = json[i]["stub"], let url = URL(string: string) {
        stubs.append(Response(url: url, stub: stub))
      }
    }

    return stubs
  }
}
