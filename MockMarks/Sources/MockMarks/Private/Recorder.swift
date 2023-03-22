import Foundation

protocol RecorderInterface {
  var recordings: [[String: Any]] { get set }
  var shouldRecord: Bool { get }

  func record(url: URL, data: Data?, response: URLResponse?, error: Error?)
}

extension MockMarks {
  /// Used to record all API calls which come through the MockMarks' `session`.
  class Recorder: RecorderInterface {
    /// An array of each recorded response in the current app session.
    var recordings = [[String: Any]]()

    private let processInfo: ProcessInfo

    init(processInfo: ProcessInfo = .processInfo) {
      self.processInfo = processInfo
    }

    /// Whether or not the app is running in the context of recording tests, as determined by
    /// the provided `ProcessInfo` object's launch environment..
    var shouldRecord: Bool {
      processInfo.environment[MockMarks.Constants.isRecording] == String(true)
    }

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
      error: Error?
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

      writeRecordings()
    }
  }
}

private extension MockMarks.Recorder {

  /// Write the current array of recordings to disk.
  func writeRecordings(fileManager: FileManager = .default) {
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
