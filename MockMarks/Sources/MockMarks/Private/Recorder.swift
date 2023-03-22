import Foundation

extension MockMarks {
  /// Used to record all API calls which come through the MockMarks' `session`.
  class Recorder {
    /// An array of each recorded response in the current app session.
    var recordings = [[String: Any]]()

    /// Makes a recording of the provided data, response, and error to the specifed URL.
    ///
    /// - Parameters:
    ///   - url: The URL to which the call being mocked was made.
    ///   - data: Optionally, the data returned from the call.
    ///   - response: Optionally, the URL response returned from the call.
    ///   - error: Optionally, the error returned from the call.
    func record(
      url: URL,
      data: Data?,
      response: URLResponse?,
      error: Error?,
      processInfo: ProcessInfo = .processInfo
    ) {
      let mockmark = MockMark(
        url: url,
        response: MockMark.Response(
          data: data,
          urlResponse: response as? HTTPURLResponse,
          error: nil
        )
      )

      recordings.insert(mockmark.asJSON, at: 0)

      writeRecordings(processInfo: processInfo)
    }
  }
}

private extension MockMarks.Recorder {

  /// Write the current array of recordings to disk.
  func writeRecordings(processInfo: ProcessInfo = .processInfo, fileManager: FileManager = .default) {
    guard let path = processInfo.environment[MockMarks.Constants.stubDirectory] else {
      return
    }

    guard let file = processInfo.environment[MockMarks.Constants.stubFilename] else {
      return
    }

    guard let data = try? JSONSerialization.data(withJSONObject: recordings) else {
      return
    }

    var url: URL
    if #available(iOS 16, *) {
      url = URL(filePath: path)
    } else {
      url = URL(fileURLWithPath: path)
    }

    try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)

    if #available(iOS 16, *) {
      url.append(path: file)
    } else {
      url.appendPathComponent(file)
    }

    try? data.write(to: url)
  }
}
