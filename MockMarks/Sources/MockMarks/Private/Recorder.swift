import Foundation

struct Recorder {

  static var recordings = [[AnyHashable: Any]]()

  static func record(url: URL, data: Data?, response: URLResponse?, error: Error?) {
    let mockmark = MockMark(
      url: url,
      response: MockMark.Response(
        data: data,
        urlResponse: response as? HTTPURLResponse,
        error: nil
      )
    )

    recordings.insert(mockmark.asJSON, at: 0)
  }
}

private extension Recorder {

  static func buildJSON(from url: URL, data: Data?, response: URLResponse?, error: Error?) -> [String: Any] {
    var json = [String: Any]()
    json["url"] = url

    return json
  }
}
