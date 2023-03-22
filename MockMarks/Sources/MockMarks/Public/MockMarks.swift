/**
 Recording:
 - Enable via the app, needs a method on MockMarks.
 - When a call is made, don't serve a mock. Instead, capture the response in the Session.
 - Need to change the JSON structure "stub" is not granular enough.
 - How should Error be represented in the JSON? Just a localized description? Anything more?
 - Once this is done, update all the examples.
 - Record the response, make JSON, write it to a file somewhere somehow.
 - Fail the mock superclass for any test by default if record mode is on. Can do this in setUp in the superclass.
 - Write some examples and tests that return different status codes and errors.
**/

import Foundation

/// The `MockMarks` enum is the core of the library, and allows you to queue stubbed responses
/// to calls to specific endpoints via the `queue` and `queueValidResponse` methods.
public enum MockMarks {

  /// A `URLSession` set to this variable will have its scheduled data tasks checked for suitable stubs.
  public static var session: MockMarks.Session?

  /// Used to toggle MockMarks' recording mode. In this mode, incoming calls through `session` will be recorded.
  static var isRecording: Bool = false

  /// The location to which recordings should be saved.
  static var recordingsURL: URL?

  /// Used to ascertain whether or not MockMarks is currently running within the context of a `MockMarksUITestCase`.
  public static var isXCUI: Bool {
    XCUIChecker.isRunning == String(true)
  }

  /// Object handling the management of responses into and out of the response queue.
  static var queue: Queue = Queue()

  /// A loader, used to read data from a JSON stub file and parse it into a stubbed response.
  private static var loader: Loader = Loader()

  /// Used to read the filename of a stub file, provided by the individual test case.
  private static let initialMockJSON = "MOCKMARKS_STUB_FILENAME"

  /// Dispatches the next queued response for the provided URL. Checks the queued response array for responses
  /// matching the given URL, and returns and removes the most recently added.
  ///
  /// - Parameters:
  ///   - url: The url for which the next queued `response` will return.
  ///   - completion: A closure to be called with the queued response.
  static func dispatchNextQueuedResponse(for url: URL, to completion: @escaping DataTask.CompletionHandler) -> Bool {
    queue.dispatchNextQueuedResponse(for: url, to: completion)
  }

  /// Performs initial setup for MockMarks. Should be called as soon as possible after your app launches
  /// so that calls made immediately following app launch can be stubbed, if required. Early exits
  /// immediately if not in the context of UI testing to avoid unnecessary processing
  ///
  /// - Parameters:
  ///   - processInfo: An injectable instance of `ProcessInfo` used to check environment variables.
  public static func setUp(processInfo: ProcessInfo = .processInfo, bundle: Bundle = .main) {
    guard processInfo.environment["MOCKMARKS_IS_XCUI"] == String(true) else {
      return
    }

    guard let directory = processInfo.environment["MOCKMARKS_STUB_DIRECTORY"] else { return }
    guard let filename = processInfo.environment["MOCKMARKS_STUB_FILENAME"] else { return }

    let url: URL
    if #available(iOS 16, *) {
      url = URL(filePath: directory).appending(path: filename)
    } else {
      url = URL(string: "A")!
    }

    guard let json = loader.loadJSON(from: url) else { return }

    json.forEach {
      queue.queue(mockmark: MockMark(url: $0.url, response: $0.response))
    }
  }
}
