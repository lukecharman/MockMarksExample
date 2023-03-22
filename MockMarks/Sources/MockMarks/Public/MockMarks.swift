import Foundation

/// The `MockMarks` enum is the core of the library, and allows you to queue stubbed responses
/// to calls to specific endpoints via the `queue` and `queueValidResponse` methods.
public enum MockMarks {

  public struct Constants {
    public static let isXCUI = "MOCKMARKS_IS_XCUI"
    public static let isRecording = "MOCKMARKS_IS_RECORDING"
    public static let stubDirectory = "MOCKMARKS_STUB_DIRECTORY"
    public static let stubFilename = "MOCKMARKS_STUB_FILENAME"
    public static let stubsFolder = "__Stubs__"
  }

  /// A `URLSession` set to this variable will have its scheduled data tasks checked for suitable mocks.
  public static var session: MockMarks.Session?

  /// Used to ascertain whether or not MockMarks is currently running within the context of a `MockMarksUITestCase`.
  public static func isXCUI(processInfo: ProcessInfo = .processInfo) -> Bool {
    processInfo.environment[Constants.isXCUI] == String(true)
  }

  /// Performs initial setup for MockMarks. Should be called as soon as possible after your app launches
  /// so that calls made immediately following app launch can be stubbed, if required. Early exits
  /// immediately if not in the context of UI testing to avoid unnecessary processing
  ///
  /// - Parameters:
  ///   - processInfo: An injectable instance of `ProcessInfo` used to check environment variables.
  public static func setUp(processInfo: ProcessInfo = .processInfo) {
    guard isXCUI(processInfo: processInfo) else { return }
    guard let directory = processInfo.environment[MockMarks.Constants.stubDirectory] else { return }
    guard let filename = processInfo.environment[MockMarks.Constants.stubFilename] else { return }

    let url: URL
    if #available(iOS 16, *) {
      url = URL(filePath: directory).appending(path: filename)
    } else {
      url = URL(fileURLWithPath: directory).appendingPathComponent(filename)
    }

    guard let json = loader.loadJSON(from: url) else { return }

    json.forEach {
      queue.queue(mockmark: MockMark(url: $0.url, response: $0.response))
    }
  }

  /// A queue, handling the management of responses into and out of the response queue.
  static var queue: Queue = Queue()

  /// A loader, used to read data from a JSON stub file and parse it into a mocked response.
  static var loader: Loader = Loader()

  /// A recorder, used to write recorded mocks out to disk.
  static var recorder: Recorder = Recorder()

  /// Dispatches the next queued response for the provided URL. Checks the queued response array for responses
  /// matching the given URL, and returns and removes the most recently added.
  ///
  /// - Parameters:
  ///   - url: The url for which the next queued `response` will return.
  ///   - completion: A closure to be called with the queued response.
  static func dispatchNextQueuedResponse(for url: URL, to completion: @escaping DataTask.CompletionHandler) -> Bool {
    queue.dispatchNextQueuedResponse(for: url, to: completion)
  }

  static func shouldRecord(processInfo: ProcessInfo = .processInfo) -> Bool {
    processInfo.environment[MockMarks.Constants.isRecording] == String(true)
  }
}
