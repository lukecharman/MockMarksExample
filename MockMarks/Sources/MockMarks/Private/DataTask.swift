import Foundation

extension MockMarks {
  /// A subclass of `URLSessionDataTask` which checks for stubbed responses. If stubs are found, they will be
  /// passed to the completion handler. If stubs are not found, the superclass will handle the function as standard.
  class DataTask: URLSessionDataTask {

    /// The underlying `URLSessionDataTask` being stubbed.
    let task: URLSessionDataTask

    /// The closure which will be called, with either stubbed or real data.
    let completionHandler: CompletionHandler

    /// Initialise a `DataTask` which wraps another `URLSessionDataTask` and can stub it.
    ///
    /// - Parameters:
    ///   - task: The underlying `URLSessionDataTask` being stubbed.
    ///   - completionHandler: The closure which will be called, with either stubbed or real data.
    ///
    /// - Returns: An instance of `DataTask` which will stub calls if mocked data exists.
    init(stubbing task: URLSessionDataTask, completionHandler: @escaping CompletionHandler) {
      self.task = task
      self.completionHandler = completionHandler
    }

    /// Begin executing the task. If a mocked response for this task is provided within MockMarks's queued responses, it will
    /// be passed to the `completionHandler`. If such a response is not provided, the superclass will handle the function.
    /// We also need to either be running UI tests, or recording to proceed with the custom implementation.
    override func resume() {
      guard let url = task.currentRequest?.url, (MockMarks.isXCUI || MockMarks.isRecording) else {
        return task.resume()
      }

      /// Ask MockMarks to mock the call. If it has a queued response, it will call the completion handler. If not, tell the task to
      /// resume using the superclass's implementation of `resume`, which may hit the real network, etc.
      if !MockMarks.dispatchNextQueuedResponse(for: url, to: completionHandler) {
        task.resume()
      }
    }
  }
}

/// Internal extensions used for cleaner-to-read code.
extension MockMarks.DataTask {
  typealias CompletionHandler = ((Data?, URLResponse?, Error?)) -> Void
}
