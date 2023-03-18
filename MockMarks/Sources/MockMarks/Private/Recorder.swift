import Foundation

extension MockMarks {
  /// Used to record all API calls which come through the MockMarks' `session`.
  struct Recorder {
    /// An array of each recorded response in the current app session.
    static var recordings = [[AnyHashable: Any]]()
    /// A name generated on each app launch for the recorded mocks.
    static let name = generateName()

    /// Makes a recording of the provided data, response, and error to the specifed URL.
    ///
    /// - Parameters:
    ///   - url: The URL to which the call being mocked was made.
    ///   - data: Optionally, the data returned from the call.
    ///   - response: Optionally, the URL response returned from the call.
    ///   - error: Optionally, the error returned from the call.
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
  }
}

private extension MockMarks.Recorder {

  /// Write the current array of recordings to disk.
  static func writeRecordings() {
    guard let fileUrl = MockMarks.recordingsURL else {
      return
    }

    var mockDirectoryUrl = fileUrl.deletingLastPathComponent().appendingPathComponent("Stubs")
    try! FileManager.default.createDirectory(at: mockDirectoryUrl, withIntermediateDirectories: true)
    mockDirectoryUrl = URL(string: mockDirectoryUrl.absoluteString.appending("\(name).json"))!

    let data = try! JSONSerialization.data(withJSONObject: recordings)

    try! data.write(to: mockDirectoryUrl)
  }

  /// Generates a unique name for each mock file generated per app launch.
  static func generateName() -> String {
    "Recording_\(ISO8601DateFormatter().string(from: Date()))"
      .replacingOccurrences(of: ":", with: ".")
  }
}
