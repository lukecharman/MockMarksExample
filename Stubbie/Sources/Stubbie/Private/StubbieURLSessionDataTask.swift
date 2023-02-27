import Foundation

/// A subclass of `URLSessionDataTask` which checks for stubbed responses. If stubs are found, they will be
/// passed to the completion handler. If stubs are not found, the superclass will handle the function as standard.
class StubbieURLSessionDataTask: URLSessionDataTask {

  /// The underlying `URLSessionDataTask` being stubbed.
  let task: URLSessionDataTask

  /// The closure which will be called, with either stubbed or real data.
  let completionHandler: (StubbieResponse) -> Void

  /// Initialise a `StubbieURLSessionDataTask` which wraps another `URLSessionDataTask` and can stub it.
  ///
  /// - Parameters:
  ///   - task: The underlying `URLSessionDataTask` being stubbed.
  ///   - completionHandler: The closure which will be called, with either stubbed or real data.
  ///
  /// - Returns: An instance of `StubbieURLSessionDataTask` which will stub calls if mocked data exists.
  init(stubbing task: URLSessionDataTask, completionHandler: @escaping (StubbieResponse) -> Void) {
    self.task = task
    self.completionHandler = completionHandler
  }

  /// Begin executing the task. If a mocked response for this task is provided within Stubbie's queued responses, it will
  /// be passed to the `completionHandler`. If such a response is not provided, the superclass will handle the function.
  override func resume() {
    guard let url = task.currentRequest?.url, Stubbie.isXCUITest else {
      return task.resume()
    }

    /// Ask Stubbie to mock the call. If it has a queued response, it will call the completion handler. If not, tell the task to
    /// resume using the superclass's implementation of `resume`, which may hit the real network, etc.
    if !Stubbie.dispatchNextQueuedResponse(for: url, to: completionHandler) {
      task.resume()
    }
  }
}
