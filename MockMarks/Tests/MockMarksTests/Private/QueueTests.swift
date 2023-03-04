import Foundation
import XCTest
@testable import MockMarks

final class QueueTests: XCTestCase {

  var queue: MockMarks.Queue!

  override func setUp() {
    super.setUp()
    queue = MockMarks.Queue()
  }

  override func tearDown() {
    queue = nil
    super.tearDown()
  }

  func test_queue_shouldCreateKey_whenItDoesNotExist() {
    queue.queue(mockmark: MockMark(url: url, response: .init(data: nil, statusCode: nil, error: nil)))
    XCTAssertNotNil(queue.queuedResponses[url])
  }

  func test_queue_shouldSaveResponse() {
    let response: MockMark.Response = .init(data: testData1, statusCode: nil, error: nil)
    queue.queue(mockmark: MockMark(url: url, response: response))
    XCTAssertEqual(queue.queuedResponses[url]?.first?.data, testData1)
  }

  func test_queue_shouldInsertResponseAtPositionZero() {
    let response1: MockMark.Response = .init(data: testData1, statusCode: nil, error: nil)
    let response2: MockMark.Response = .init(data: testData2, statusCode: nil, error: nil)
    queue.queue(mockmark: MockMark(url: url, response: response1))
    queue.queue(mockmark: MockMark(url: url, response: response2))
    XCTAssertEqual(queue.queuedResponses[url]?[0].data, testData2)
    XCTAssertEqual(queue.queuedResponses[url]?[1].data, testData1)
  }

  func test_queue_shouldPreserveStatusCode() {
    let response: MockMark.Response = .init(data: nil, statusCode: urlResponse.statusCode, error: nil)
    queue.queue(mockmark: MockMark(url: url, response: response))

    let statusCode = queue.queuedResponses[url]?.first?.statusCode
    XCTAssertEqual(url, urlResponse.url)
    XCTAssertEqual(statusCode, urlResponse.statusCode)
  }

  func test_queue_shouldPreserveError() {
    let response: MockMark.Response = .init(data: nil, statusCode: nil, error: error)
    queue.queue(mockmark: MockMark(url: url, response: response))

    let savedError = queue.queuedResponses[url]?.first?.error
    XCTAssertEqual(savedError?.localizedDescription, error.localizedDescription)
  }

  func test_dispatchNextQueuedResponse_shouldReturnFalse_whenURLHasNoQueuedResponses() {
    XCTAssertFalse(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
  }

  func test_dispatchNextQueuedResponse_shouldReturnTrue_whenURLHasQueuedResponses() {
    queue.queue(mockmark: MockMark(url: url, response: emptyResponse))
    XCTAssertTrue(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
  }

  func test_dispatchNextQueuedResponse_shouldReturnTrue_multipleTimes_thenFalse() {
    queue.queue(mockmark: MockMark(url: url, response: emptyResponse))
    queue.queue(mockmark: MockMark(url: url, response: emptyResponse))
    queue.queue(mockmark: MockMark(url: url, response: emptyResponse))
    XCTAssertTrue(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
    XCTAssertTrue(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
    XCTAssertTrue(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
    XCTAssertFalse(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
  }

  func test_dispatchNextQueuedResponse_shouldCallCompletion() {
    let exp = expectation(description: #function)
    queue.queue(mockmark: MockMark(url: url, response: emptyResponse))
    _ = queue.dispatchNextQueuedResponse(for: url) { _ in exp.fulfill() }
    waitForExpectations(timeout: 0.01)
  }

  var url: URL {
    URL(string: "A")!
  }

  var emptyResponse: MockMark.Response {
    MockMark.Response(data: nil, statusCode: nil, error: nil)
  }

  var testData1: Data {
    String("ABC").data(using: .utf8)!
  }

  var testData2: Data {
    String("DEF").data(using: .utf8)!
  }

  var urlResponse: HTTPURLResponse {
    HTTPURLResponse(url: url, statusCode: 123, httpVersion: nil, headerFields: nil)!
  }

  var error: Error {
    TestError.forTesting
  }

  private enum TestError: Error {
    case forTesting

    var localizedDescription: String {
      "Testing"
    }
  }
}
