import Foundation

extension MockMarks {

  /// Used to queue stubbed responses to calls to various endpoints.
  class Queue {

    /// A set of responses. Calls to URLs matching the keys will sequentially be stubbed with data in the response.
    var queuedResponses = [URL: [Response]]()

    /// Queues a provided response to a given URL. With this function, you can stub the data returned, as well as the
    /// `URLResponse` and any potential `Error`s, to see how your app handles them.
    ///
    /// - Parameters:
    ///   - response: The response to be returned.
    ///   - url: The url for which `response` will return.
    func queue(response: Response, from url: URL) {
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
    func queueValidResponse(with json: Any, from url: URL) throws {
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
    func dispatchNextQueuedResponse(for url: URL, to completion: @escaping CompletionHandler) -> Bool {
      guard let next = queuedResponses[url]?.popLast() else {
        return false
      }

      completion(next)

      return true
    }

  }
}
