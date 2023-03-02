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
    queue.queue(response: (nil, nil, nil), from: url)
    XCTAssertNotNil(queue.queuedResponses[url])
  }

  func test_queue_shouldSaveResponse() {
    let response: MockMarks.Response = (testData1, nil, nil)
    queue.queue(response: response, from: url)
    XCTAssertEqual(queue.queuedResponses[url]?.first?.0, testData1)
  }

  func test_queue_shouldInsertResponseAtPositionZero() {
    let response1: MockMarks.Response = (testData1, nil, nil)
    let response2: MockMarks.Response = (testData2, nil, nil)
    queue.queue(response: response1, from: url)
    queue.queue(response: response2, from: url)
    XCTAssertEqual(queue.queuedResponses[url]?[0].0, testData2)
    XCTAssertEqual(queue.queuedResponses[url]?[1].0, testData1)
  }

  func test_queue_shouldPreserveStatusCode() {
    let response: MockMarks.Response = (nil, urlResponse, nil)
    queue.queue(response: response, from: url)
    let httpResponse = queue.queuedResponses[url]?.first?.1 as! HTTPURLResponse
    XCTAssertEqual(httpResponse.url, urlResponse.url)
    XCTAssertEqual(httpResponse.statusCode, urlResponse.statusCode)
  }

  func test_queue_shouldPreserveError() {
    let response: MockMarks.Response = (nil, nil, error)
    queue.queue(response: response, from: url)
    let savedError = queue.queuedResponses[url]?.first?.2
    XCTAssertEqual(savedError?.localizedDescription, error.localizedDescription)
  }

  func test_queueValidResponse_shouldQueueJSONAsData() {
    let json = ["A": "B"]
    try! queue.queueValidResponse(with: json, from: url)
    let data = try! JSONSerialization.data(withJSONObject: json)
    XCTAssertEqual(queue.queuedResponses[url]?[0].0, data)
  }

  func test_queueValidResponse_shouldQueueWithA200() {
    try! queue.queueValidResponse(with: [], from: url)
    XCTAssertEqual((queue.queuedResponses[url]?[0].1 as! HTTPURLResponse).statusCode, 200)
  }

  func test_queueValidResponse_shouldQueueWithNoError() {
    try! queue.queueValidResponse(with: [], from: url)
    XCTAssertNil(queue.queuedResponses[url]?[0].2)
  }

  func test_dispatchNextQueuedResponse_shouldReturnFalse_whenURLHasNoQueuedResponses() {
    XCTAssertFalse(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
  }

  func test_dispatchNextQueuedResponse_shouldReturnTrue_whenURLHasQueuedResponses() {
    try! queue.queueValidResponse(with: [], from: url)
    XCTAssertTrue(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
  }

  func test_dispatchNextQueuedResponse_shouldReturnTrue_multipleTimes_thenFalse() {
    try! queue.queueValidResponse(with: [], from: url)
    try! queue.queueValidResponse(with: [], from: url)
    try! queue.queueValidResponse(with: [], from: url)
    XCTAssertTrue(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
    XCTAssertTrue(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
    XCTAssertTrue(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
    XCTAssertFalse(queue.dispatchNextQueuedResponse(for: url, to: { _, _, _ in }))
  }

  func test_dispatchNextQueuedResponse_shouldCallCompletion() {
    let exp = expectation(description: #function)
    try! queue.queueValidResponse(with: ["A": "B"], from: url)
    _ = queue.dispatchNextQueuedResponse(for: url) { _ in exp.fulfill() }
    waitForExpectations(timeout: 0.01)
  }

  var url: URL {
    URL(string: "A")!
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
