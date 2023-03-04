import Foundation

struct Recorder {

  static func record(url: URL, data: Data?, response: URLResponse?, error: Error?) {

  }
}

private extension Recorder {

  static func buildJSON(from url: URL, data: Data?, response: URLResponse?, error: Error?) -> [String: Any] {
    var json = [String: Any]()

    json["url"] = url

    return json
  }
}
