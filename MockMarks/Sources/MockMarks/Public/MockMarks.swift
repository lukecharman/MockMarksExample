import Foundation

/// The `MockMarks` enum is the core of the library, and allows you to queue stubbed responses
/// to calls to specific endpoints via the `queue` and `queueValidResponse` methods.
public enum MockMarks {

  /// A `URLSession` set to this variable will have its scheduled data tasks checked for suitable stubs.
  public static var session: MockMarks.Session?

  /// Used to ascertain whether or not MockMarks is currently running within the context of a `MockMarksUITestCase`.
  public static var isXCUI: Bool {
    XCUIChecker.isRunning == String(true)
  }

  /// Object handling the management of responses into and out of the response queue.
  static var queue: Queue = Queue()

  /// A loader, used to read data from a JSON stub file and parse it into a stubbed response.
  private static var loader: Loader = Loader()

  /// Used to read the filename of a stub file, provided by the individual test case.
  private static let initialMockJSON = "XCUI_INITIAL_MOCK_JSON"

  /// Dispatches the next queued response for the provided URL. Checks the queued response array for responses
  /// matching the given URL, and returns and removes the most recently added.
  ///
  /// - Parameters:
  ///   - url: The url for which the next queued `response` will return.
  ///   - completion: A closure to be called with the queued response.
  static func dispatchNextQueuedResponse(for url: URL, to completion: @escaping CompletionHandler) -> Bool {
    queue.dispatchNextQueuedResponse(for: url, to: completion)
  }

  /// Performs initial setup for MockMarks. Should be called as soon as possible after your app launches
  /// so that calls made immediately following app launch can be stubbed, if required. Early exits
  /// immediately if not in the context of UI testing to avoid unnecessary processing
  ///
  /// - Parameters:
  ///   - processInfo: An injectable instance of `ProcessInfo` used to check environment variables.
  public static func setUp(processInfo: ProcessInfo = .processInfo, bundle: Bundle = .main) {
    guard processInfo.environment["XCUI_IS_RUNNING"] == String(true) else { return }

    guard let initial = processInfo.environment[MockMarks.initialMockJSON] else { return }
    guard let json = loader.loadJSON(named: initial, in: bundle) else { return }

    json.forEach {
      try? queue.queueValidResponse(with: $0.stub, from: $0.url)
    }
  }
}

/// Internal extensions used for cleaner-to-read code.
extension MockMarks {
  typealias Response = (Data?, URLResponse?, Error?)
  typealias CompletionHandler = (Response) -> Void
}
