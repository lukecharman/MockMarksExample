import Foundation

/// A tuple matching the completion handler type of `URLSession`'s data task methods.
typealias StubbieResponse = (Data?, URLResponse?, Error?)

/// The `Stubbie` enum is the core of the library, and allows you to queue stubbed responses
/// to calls to specific endpoints via the `queue` and `queueValidResponse` methods.
public enum Stubbie {

  /// A `URLSession` set to this variable will have its scheduled data tasks checked for suitable stubs.
  public static var session: StubbieURLSession?

  /// A set of responses. Calls to URLs matching the keys will sequentially be stubbed with data in the response.
  private static var queuedResponses = [URL: [StubbieResponse]]()

  /// A loader, used to read data from a JSON stub file and parse it into a stubbed response.
  private static var loader: StubbieLoader = StubbieLoader()

  /// Used to read the filename of a stub file, provided by the individual test case.
  private static let initialMockJSON = "XCUI_INITIAL_MOCK_JSON"

  /// Queues a provided response to a given URL. With this function, you can stub the data returned, as well as the
  /// `URLResponse` and any potential `Error`s, to see how your app handles them.
  ///
  /// - Parameters:
  ///   - response: The response to be returned.
  ///   - url: The url for which `response` will return.
  static func queue(response: StubbieResponse, from url: URL) {
    if queuedResponses[url] == nil {
      queuedResponses[url] = []
    }

    queuedResponses[url]?.insert(response, at: 0)
  }

  /// Queues a provided response to a given URL, defaulting the `URLResponse` to a 200 OK HTTP response, and
  /// automatically setting the `Error` to `nil`. A convenience queuer for a valid response.
  ///
  /// - Parameters:
  ///   - json: The JSON object to be returned.
  ///   - url: The url for which `json`'s response will return.
  static func queueValidResponse(with json: Any, from url: URL) throws {
    let data = try JSONSerialization.data(withJSONObject: json, options: [])

    if queuedResponses[url] == nil {
      queuedResponses[url] = []
    }

    let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
    queuedResponses[url]?.insert((data, response, nil), at: 0)
  }

  /// Dispatches the next queued response for the provided URL. Checks the queued response array for responses
  /// matching the given URL, and returns and removes the most recently added.
  ///
  /// - Parameters:
  ///   - url: The url for which the next queued `response` will return.
  ///   - completion: A closure to be called with the queued response.
  static func dispatchNextQueuedResponse(for url: URL, to completion: @escaping (StubbieResponse) -> Void) -> Bool {
    guard let next = queuedResponses[url]?.popLast() else {
      return false
    }

    completion(next)

    return true
  }

  /// Used to ascertain whether or not Stubbie is currently running within the context of a `StubbieUITestCase`.
  public static var isXCUITest: Bool {
    ProcessInfo.processInfo.environment["XCUI_IS_RUNNING"] == String(true)
  }

  /// Performs initial setup for Stubbie. Should be called as soon as possible after your app launches
  /// so that calls made immediately following app launch can be stubbed, if required. Early exits
  /// immediately if not in the context of UI testing to avoid unnecessary processing
  ///
  /// - Parameters:
  ///   - processInfo: An injectable instance of `ProcessInfo` used to check environment variables.
  public static func setUp(processInfo: ProcessInfo = .processInfo) {
    guard Stubbie.isXCUITest else { return }

    guard let initial = processInfo.environment[Stubbie.initialMockJSON] else { return }
    guard let json = loader.loadJSON(named: initial) else { return }

    json.forEach {
      try? Stubbie.queueValidResponse(with: $0.stub, from: $0.url)
    }
  }
}
