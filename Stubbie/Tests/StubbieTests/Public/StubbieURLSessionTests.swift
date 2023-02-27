import Foundation
import XCTest
@testable import Stubbie

final class StubbieURLSessionTests: XCTestCase {

  private var mockURLSession: MockURLSession!
  private var stubbieSession: StubbieURLSession!

  override func setUp() {
    super.setUp()
    mockURLSession = MockURLSession()
    stubbieSession = StubbieURLSession(stubbing: mockURLSession)
  }

  override func tearDown() {
    stubbieSession = nil
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
    let sut = StubbieURLSession(stubbing: .shared)
    XCTAssertIdentical(sut.urlSession, URLSession.shared)
  }

  // MARK: - dataTaskWithURLRequest

  func test_dataTaskWithURLRequest_shouldReturnAppropriateSubclass() {
    let task = stubbieSession.dataTask(with: urlRequest, completionHandler: completion)
    XCTAssert(task is StubbieURLSessionDataTask)
  }

  func test_dataTaskWithURLRequest_shouldProxyCompletionHandlerToSuperclass() {
    _ = stubbieSession.dataTask(with: urlRequest) { data, _, _ in
      XCTAssertEqual(data!, self.stringData)
    }
  }

  // MARK: - dataTaskWithURL

  func test_dataTaskWithURL_shouldProxyResponseFromSuperclass() {
    _ = stubbieSession.dataTask(with: url) { _, _, _ in }
    XCTAssert(mockURLSession.didCallDataTaskWithURL)
  }

  func test_dataTaskWithURL_shouldProxyCompletionHandlerToSuperclass() {
    _ = stubbieSession.dataTask(with: url) { data, _, _ in
      XCTAssertEqual(data!, self.stringData)
    }
  }
}

private class MockURLSession: URLSession {
  var didCallDataTaskWithURLRequest = false
  var didCallDataTaskWithURL = false

  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    didCallDataTaskWithURLRequest = true
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    return MockStubbieURLSessionDataTask(stubbing: task, completionHandler: completionHandler)
  }

  override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    didCallDataTaskWithURL = true
    let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
    return MockStubbieURLSessionDataTask(stubbing: task, completionHandler: completionHandler)
  }
}

private class MockStubbieURLSessionDataTask: StubbieURLSessionDataTask {
  override init(stubbing task: URLSessionDataTask, completionHandler: @escaping (StubbieResponse) -> Void) {
    super.init(stubbing: task, completionHandler: completionHandler)
    completionHandler(("Test".data(using: .utf16)!, nil, nil))
  }
}
