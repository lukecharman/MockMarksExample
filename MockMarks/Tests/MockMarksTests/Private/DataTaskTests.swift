import Foundation
import XCTest
@testable import MockMarks

final class DataTaskTests: XCTestCase {

  func test_init_shouldStoreTask() {
    let task = URLSessionDataTask()
    let MockMarksTask = MockMarks.DataTask(stubbing: task, completionHandler: { _, _ ,_ in })
    XCTAssertIdentical(task, MockMarksTask.task)
  }

  func test_resume_shouldDeferToSuperclass_whenTaskHasNoURL() {
    let task = MockURLSessionDataTask()
    let MockMarksTask = MockMarks.DataTask(stubbing: task, completionHandler: { _, _, _ in})
    MockMarksTask.resume()
    XCTAssert(task.didCallResume)
  }

  func test_resume_shouldDeferToSuperclass_whenNotRunningXCUI() {
    let task = MockURLSessionDataTask()
    task.mockedCurrentRequest = URLRequest(url: URL(string: "A")!)

    let MockMarksTask = MockMarks.DataTask(stubbing: task, completionHandler: { _, _, _ in })
    MockMarksTask.resume()
    XCTAssert(task.didCallResume)
  }

  func test_resume_shouldDeferToSuperclass_whenNoQueuedResponseIsAvailable() {
    XCUIChecker.isRunning = "true"

    let task = MockURLSessionDataTask()
    task.mockedCurrentRequest = URLRequest(url: URL(string: "A")!)

    let MockMarksTask = MockMarks.DataTask(stubbing: task, completionHandler: { _, _, _ in })
    MockMarksTask.resume()
    XCTAssert(task.didCallResume)
  }

  func test_resume_shouldReturnNextStubbedResponse_whenAvailable() {
    XCUIChecker.isRunning = "true"

    let url = URL(string: "A")!
    let data = try! JSONSerialization.data(withJSONObject: ["A": "B"])
    let response = MockMark.Response(data: data, statusCode: nil, error: nil)
    MockMarks.queue.queue(mockmark: MockMark(url: URL(string: "A")!, response: response))

    let task = MockURLSessionDataTask()
    task.mockedCurrentRequest = URLRequest(url: url)

    MockMarks.DataTask(stubbing: task) { data, _, _ in
      guard let data = data else {
        return XCTFail(#function)
      }

      guard let json = try? JSONSerialization.jsonObject(with: data) as? [AnyHashable: Any] else {
        return XCTFail(#function)
      }

      XCTAssertEqual(json["A"] as? String, "B")
    }.resume()

    XCTAssertFalse(task.didCallResume)
  }
}

private class MockURLSessionDataTask: URLSessionDataTask {

  var didCallResume = false
  var mockedCurrentRequest: URLRequest?

  override func resume() {
    didCallResume = true
  }

  override var currentRequest: URLRequest? {
    mockedCurrentRequest
  }
}
