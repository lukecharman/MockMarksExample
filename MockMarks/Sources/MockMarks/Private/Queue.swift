import Foundation

extension MockMarks {

  /// Used to queue stubbed responses to calls to various endpoints.
  class Queue {

    /// A set of responses. Calls to URLs matching the keys will sequentially be stubbed with data in the response.
    var queuedResponses = [URL: [MockMark.Response]]()

    /// Queues a provided response to a given URL. With this function, you can stub the data returned, as well as the
    /// `URLResponse` and any potential `Error`s, to see how your app handles them.
    ///
    /// - Parameters:
    ///   - response: The response to be returned.
    ///   - url: The url for which `response` will return.
    func queue(mockmark: MockMark) {
      if queuedResponses[mockmark.url] == nil {
        queuedResponses[mockmark.url] = []
      }

      queuedResponses[mockmark.url]?.insert(mockmark.response, at: 0)
    }

    /// Dispatches the next queued response for the provided URL. Checks the queued response array for responses
    /// matching the given URL, and returns and removes the most recently added.
    ///
    /// - Parameters:
    ///   - url: The url for which the next queued `response` will return.
    ///   - completion: A closure to be called with the queued response.
    func dispatchNextQueuedResponse(for url: URL, to completion: @escaping DataTask.CompletionHandler) -> Bool {
      guard let next = queuedResponses[url]?.popLast() else {
        return false
      }

      completion((next.data, nil, nil))

      return true
    }

  }
}
