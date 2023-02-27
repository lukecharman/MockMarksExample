import Foundation

/// A tuple matching the completion handler type of `URLSession`'s data task methods.
typealias StubbieResponse = (Data?, URLResponse?, Error?)

public enum Stubbie {

  enum Constants {
    public static let isRunningXCUI = "XCUI_IS_RUNNING"
    public static let initialMockJSON = "XCUI_INITIAL_MOCK_JSON"
  }

  public static var session: StubbieURLSession?

  private static var queuedResponses = [URL: [StubbieResponse]]()

  static func queue(response: StubbieResponse, from url: URL) {
    if queuedResponses[url] == nil {
      queuedResponses[url] = []
    }

    queuedResponses[url]?.insert(response, at: 0)
  }

  static func queueValidResponse(with json: Any, from url: URL) throws {
    let data = try JSONSerialization.data(withJSONObject: json, options: [])

    if queuedResponses[url] == nil {
      queuedResponses[url] = []
    }

    let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
    queuedResponses[url]?.insert((data, response, nil), at: 0)
  }

  static func dispatchNextQueuedResponse(for url: URL, to completion: @escaping (StubbieResponse) -> Void) -> Bool {
    guard let next = queuedResponses[url]?.popLast() else {
      return false
    }

    completion(next)

    return true
  }

  public static var isXCUITest: Bool {
    ProcessInfo.processInfo.environment[Stubbie.Constants.isRunningXCUI] == String(true)
  }

  public static func setUp() {
    // We only want to do anything if we're in an XCUI target.
    guard Stubbie.isXCUITest else { return }

    // Load the JSON file containing our stubs for this test, if they exist.
    guard let initial = ProcessInfo.processInfo.environment[Stubbie.Constants.initialMockJSON] else { return }
    guard let json = StubbieLoader.loadJSON(named: initial) else { return }

    json.forEach {
      try? Stubbie.queueValidResponse(with: $0.stub, from: $0.url)
    }
  }
}
