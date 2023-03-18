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

    writeRecordings()
  }

  static func writeRecordings() {
    guard let name = ProcessInfo.processInfo.environment["XCUI_RECORDING_TEST_NAME"] else {
      return
    }

    // Need a way to pass the app's root path + \Stubs\ here.

    guard let fileUrl = MockMarks.recordingsURL else {
      fatalError()
    }

    var mockDirectoryUrl = fileUrl.deletingLastPathComponent().appendingPathComponent("Stubs")
    try! FileManager.default.createDirectory(at: mockDirectoryUrl, withIntermediateDirectories: true)
    mockDirectoryUrl = URL(string: mockDirectoryUrl.absoluteString.appending("\(name).json"))!

    let data = try! JSONSerialization.data(withJSONObject: recordings)

    try! data.write(to: mockDirectoryUrl)
  }
}

private extension Recorder {

  static func buildJSON(from url: URL, data: Data?, response: URLResponse?, error: Error?) -> [String: Any] {
    var json = [String: Any]()
    json["url"] = url

    return json
  }
}
