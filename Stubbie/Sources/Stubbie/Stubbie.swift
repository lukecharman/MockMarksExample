import Foundation

typealias Response = (Data?, URLResponse?, Error?)

public class Stubbie {

  public static var session: StubbieURLSession?
  internal static var queuedResponses = [URL: [Response]]()

  static func queue(response: Response, from url: URL) {
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

    queuedResponses[url]?.insert((data, valid200Response(from: url), nil), at: 0)
  }

  static func dispatchNextQueuedResponse(for url: URL, to completion: @escaping (Response) -> Void) {
    guard let next = queuedResponses[url]?.popLast() else {
      return
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      completion(next)
    }
  }
}

private extension Stubbie {

  private static func valid200Response(from url: URL) -> URLResponse? {
    return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
  }
}

public extension Stubbie {

  enum K {
    public static let isRunningXCUI = "XCUI_IS_RUNNING"
    public static let initialMockJSON = "XCUI_INITIAL_MOCK_JSON"
  }

  static var isXCUITest: Bool {
    ProcessInfo.processInfo.environment[Stubbie.K.isRunningXCUI] == String(true)
  }

  static var initialMockJSON: String? {
    ProcessInfo.processInfo.environment[Stubbie.K.initialMockJSON]
  }
}

public extension Stubbie {

  static func setUp() {
    // We only want to do anything if we're in an XCUI target.
    guard Stubbie.isXCUITest else { return }

    // Load the JSON file containing our stubs for this test, if they exist.
    guard let initial = Stubbie.initialMockJSON, let json = loadJSON(named: initial) else { return }
    try? Stubbie.queueValidResponse(with: json.stub, from: json.url)
  }

  private static func loadJSON(named name: String) -> (url: URL, stub: Any)? {
    guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "json") else { return nil }
    guard let data = try? Data(contentsOf: bundleURL) else { return nil }
    guard let json = try? JSONSerialization.jsonObject(with: data) as? [[AnyHashable: Any]] else { return nil }

    return (url: URL(string: json[0]["url"] as! String)!, stub: json[0]["stub"] as Any)
  }
}

public class StubbieURLSession: URLSession {

  private let urlSession: URLSession

  public init(stubbing session: URLSession = .shared) {
    self.urlSession = session
  }

  override public func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    StubbieDataTask(
      stubbing: urlSession.dataTask(with: request, completionHandler: completionHandler),
      completionHandler: completionHandler
    )
  }

  override public func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    StubbieDataTask(
      stubbing: urlSession.dataTask(with: url, completionHandler: completionHandler),
      completionHandler: completionHandler
    )
  }
}

class StubbieDataTask: URLSessionDataTask {

  private let task: URLSessionDataTask
  private let completionHandler: (Response) -> Void

  init(stubbing task: URLSessionDataTask, completionHandler: @escaping (Response) -> Void) {
    self.task = task
    self.completionHandler = completionHandler
  }

  override func resume() {
    guard let url = task.currentRequest?.url else {
      return task.resume()
    }

    Stubbie.isXCUITest ? Stubbie.dispatchNextQueuedResponse(for: url, to: completionHandler) : task.resume()
  }
}

