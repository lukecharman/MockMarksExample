import Foundation

/// A subclass of `URLSession` which injects Stubbie's subclassed `URLSessionDataTask` objects.
public class StubbieURLSession: URLSession {

  /// The underlying `URLSession` being stubbed.
  let urlSession: URLSession

  /// Initialise a `StubbieURLSession` which wraps another `URLSession` and can stub its data tasks.
  ///
  /// - Parameters:
  ///   - session: The underlying `URLSession` being stubbed.
  ///
  /// - Returns: An instance of `StubbieURLSession` which will stub calls as requested.
  public init(stubbing session: URLSession = .shared) {
    self.urlSession = session
  }

  /// Create a `StubbieURLSessionDataTask` (as a standard `URLSessionDataTask`)
  /// which can be used to return stubbed responses from the response queue.
  ///
  /// - Parameters:
  ///   - request: The request to be stubbed.
  ///   - completionHandler: A callback which will be called with eithert stubbed or real data.
  ///
  /// - Returns: An instance of `StubbieURLSessionDataTask` typed as a `URLSessionDataTask`.
  override public func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    StubbieURLSessionDataTask(
      stubbing: urlSession.dataTask(with: request, completionHandler: completionHandler),
      completionHandler: completionHandler
    )
  }

  /// Create a `StubbieURLSessionDataTask` (as a standard `URLSessionDataTask`)
  /// which can be used to return stubbed responses from the response queue.
  ///
  /// - Parameters:
  ///   - url: The URL from which responses will be stubbed.
  ///   - completionHandler: A callback which will be called with eithert stubbed or real data.
  ///
  /// - Returns: An instance of `StubbieURLSessionDataTask` typed as a `URLSessionDataTask`.
  override public func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    StubbieURLSessionDataTask(
      stubbing: urlSession.dataTask(with: url, completionHandler: completionHandler),
      completionHandler: completionHandler
    )
  }
}
