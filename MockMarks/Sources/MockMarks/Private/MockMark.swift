import Foundation

/// A data structure representing a mocked response to a specific URL.
struct MockMark {
  /// The URL to which queries will return the associated stub.
  let url: URL
  /// The stubbed response which will be returned to the `Response`'s `url`.
  let response: Response

  /// Packages the different parts of a stubbed response.
  struct Response {
    /// The data returned.
    let data: Data?
    /// The HTTP URL response of the stub.
    let urlResponse: HTTPURLResponse?
    /// A dictionary containing error information that the stub can return if present.
    let error: [String: Any]?
    /// The data converted to JSON.
    var json: Any? {
      guard let data else { return nil }
      return try? JSONSerialization.jsonObject(with: data)
    }
  }

  /// Display the MockMark encoded as a JSON dictionary.
  var asJSON: [String: Any] {
    var json = [String: Any]()

    json["url"] = url.absoluteString

    var mock = [String: Any]()

    if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data) {
      mock["json"] = json
    }

    if let code = response.urlResponse?.statusCode {
      mock["responseCode"] = code
    }

    if let error = response.error {
      mock["error"] = error
    }

    json["mock"] = mock

    return json
  }
}
