import Foundation
import XCTest
@testable import MockMarks

final class SessionTests: XCTestCase {

  private var mockURLSession: MockSession!
  private var MockMarksSession: MockMarks.Session!

  override func setUp() {
    super.setUp()
    mockURLSession = MockSession()
    MockMarks.Recorder.recordings.removeAll()
    MockMarksSession = MockMarks.Session(mocking: mockURLSession)
  }

  override func tearDown() {
    MockMarksSession = nil
    mockURLSession = nil
    super.tearDown()
  }

  private var urlRequest: URLRequest {
    URLRequest(url: url)
  }

  private var url: URL {
    URL(string: "https://api.com/endpoint")!
  }

  private var stringData: Data {
    "Test".data(using: .utf16)!
  }

  private var completion: (Data?, URLResponse?, Error?) -> Void {
    { _, _, _ in }
  }

  // MARK: - init

  func test_init_shouldStoreURLSession() {
    let sut = MockMarks.Session(mocking: .shared)
    XCTAssertIdentical(sut.urlSession, URLSession.shared)
  }

  // MARK: - dataTaskWithURLRequest

  func test_dataTaskWithURLRequest_shouldReturnAppropriateSubclass() {
    let task = MockMarksSession.dataTask(with: urlRequest, completionHandler: completion)
    XCTAssert(task is MockMarks.DataTask)
  }

  func test_dataTaskWithURLRequest_shouldDeferCompletionHandlerToSuperclass() {
    _ = MockMarksSession.dataTask(with: urlRequest) { data, _, _ in
      XCTAssertEqual(data!, self.stringData)
    }
  }

  func test_dataTaskWithURLRequest_shouldRecordWhenRecordingIsEnabled() {

  }

  func test_dataTaskWithURLRequest_shouldNotRecordWhenRecordingIsDisabled() {
    _ = MockMarksSession.dataTask(with: url) { _, _, _ in }
    XCTAssert(mockURLSession.didCallDataTaskWithURL)
    XCTAssert(MockMarks.Recorder.recordings.isEmpty)
  }

  // MARK: - dataTaskWithURL

  func test_dataTaskWithURL_shouldDeferResponseFromSuperclass() {
    _ = MockMarksSession.dataTask(with: url) { _, _, _ in }
    XCTAssert(mockURLSession.didCallDataTaskWithURL)
  }

  func test_dataTaskWithURL_shouldDeferCompletionHandlerToSuperclass() {
    _ = MockMarksSession.dataTask(with: url) { data, _, _ in
      XCTAssertEqual(data!, self.stringData)
    }
  }
}

private class MockSession: URLSession {
  var didCallDataTaskWithURLRequest = false
  var didCallDataTaskWithURL = false

  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    didCallDataTaskWithURLRequest = true
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    return MockDataTask(mocking: task, completionHandler: completionHandler)
  }

  override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    didCallDataTaskWithURL = true
    let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
    return MockDataTask(mocking: task, completionHandler: completionHandler)
  }
}

private class MockDataTask: MockMarks.DataTask {
  override init(mocking task: URLSessionDataTask, completionHandler: @escaping MockMarks.DataTask.CompletionHandler) {
    super.init(mocking: task, completionHandler: completionHandler)
    completionHandler(("Test".data(using: .utf16)!, nil, nil))
  }
}
