import Foundation

extension MockMarks {

  /// A subclass of `URLSession` which injects MockMarks's subclassed `URLSessionDataTask` objects.
  public class Session: URLSession {

    /// The underlying `URLSession` being stubbed.
    let urlSession: URLSession

    /// Initialise a `Session` which wraps another `URLSession` and can stub its data tasks.
    ///
    /// - Parameters:
    ///   - session: The underlying `URLSession` being stubbed.
    ///
    /// - Returns: An instance of `Session` which will stub calls as requested.
    public init(stubbing session: URLSession = .shared) {
      self.urlSession = session
    }

    /// Create a `MockMarksURLSessionDataTask` (as a standard `URLSessionDataTask`)
    /// which can be used to return stubbed responses from the response queue.
    ///
    /// - Parameters:
    ///   - request: The request to be stubbed.
    ///   - completionHandler: A callback which will be called with eithert stubbed or real data.
    ///
    /// - Returns: An instance of `MockMarksURLSessionDataTask` typed as a `URLSessionDataTask`.
    override public func dataTask(
      with request: URLRequest,
      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
      let superTask = urlSession.dataTask(with: request, completionHandler: { data, response, error in
        if MockMarks.isRecording, let url = request.url {
          Recorder.record(url: url, data: data, response: response, error: error)
        }
        completionHandler(data, response, error)
      })

      return DataTask(stubbing: superTask, completionHandler: completionHandler)
    }

    /// Create a `MockMarksURLSessionDataTask` (as a standard `URLSessionDataTask`)
    /// which can be used to return stubbed responses from the response queue.
    ///
    /// - Parameters:
    ///   - url: The URL from which responses will be stubbed.
    ///   - completionHandler: A callback which will be called with eithert stubbed or real data.
    ///
    /// - Returns: An instance of `MockMarksURLSessionDataTask` typed as a `URLSessionDataTask`.
    override public func dataTask(
      with url: URL,
      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
      DataTask(
        stubbing: urlSession.dataTask(with: url, completionHandler: { data, response, error in
          if MockMarks.isRecording {
            Recorder.record(url: url, data: data, response: response, error: error)
          }
          completionHandler(data, response, error)
        }),
        completionHandler: completionHandler
      )
    }
  }
}
