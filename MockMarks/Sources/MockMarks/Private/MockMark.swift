import Foundation

/// A data structure representing a mocked response to a specific URL.
struct MockMark: Hashable {
  /// The URL to which queries will return the associated stub.
  let url: URL
  /// The stubbed response which will be returned to the `Response`'s `url`.
  let response: Response

  func hash(into hasher: inout Hasher) {
    hasher.combine(url)
  }

  /// Equatable conformance.
  static func == (lhs: MockMark, rhs: MockMark) -> Bool {
    lhs.url == rhs.url
  }

  /// Packages the different parts of a stubbed response.
  struct Response {
    /// The data returned.
    let data: Data?
    /// The HTTP status code of the stubbed response.
    let statusCode: Int?
    /// A dictionary containing error information that the stub can return if present.
    let error: Error?

    func httpResponse(to url: URL) -> HTTPURLResponse? {
      HTTPURLResponse(url: url, statusCode: statusCode ?? 200, httpVersion: nil, headerFields: nil)
    }

    var json: Any? {
      guard let data else { return nil }
      return try? JSONSerialization.jsonObject(with: data)
    }
  }
}
