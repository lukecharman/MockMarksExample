import Foundation
import XCTest
@testable import MockMarks

final class MockMarksTests: XCTestCase {

  override func setUp() {
    super.setUp()
    MockMarks.queue.queuedResponses.removeAll()
  }

  func test_session_shouldBeStored() {
    let session = MockMarks.Session(stubbing: .shared)
    MockMarks.session = session
    XCTAssertEqual(MockMarks.session, session)
  }

  func test_isXCUI_shouldReferToXCUIChecker() {
    XCUIChecker.isRunning = String(true)
    XCTAssert(MockMarks.isXCUI)

    XCUIChecker.isRunning = String(false)
    XCTAssertFalse(MockMarks.isXCUI)
  }

  func test_dispatchNextQueuedResponse_shouldCallCompletion() {
    let data = try! JSONSerialization.data(withJSONObject: ["A": "B"])
    let response = MockMark.Response(data: data, urlResponse: nil, error: nil)
    let mockmark = MockMark(url: url, response: response)

    MockMarks.queue.queue(mockmark: mockmark)
    _ = MockMarks.dispatchNextQueuedResponse(for: url) { data, _, _ in
      let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [AnyHashable: Any]
      XCTAssertEqual(json["A"] as! String, "B")
    }
  }

  func test_setUp_shouldNotLoadJSON_whenXCUIIsNotRunning() {
    let processInfo = MockProcessInfo()
    processInfo.isRunningXCUI = false
    MockMarks.setUp(processInfo: processInfo, bundle: .module)
    XCTAssert(MockMarks.queue.queuedResponses.isEmpty)
  }

  func test_setUp_shouldNotLoadJSON_whenNoFileToLoadIsSet() {
    let processInfo = MockProcessInfo()
    processInfo.mockedEnvironment = ["MOCKMARKS_IS_XCUI": String(true)]
    MockMarks.setUp(processInfo: processInfo, bundle: .module)
    XCTAssert(MockMarks.queue.queuedResponses.isEmpty)
  }

  func test_setUp_shouldNotQueue_whenJSONFailsToLoad() {
    let processInfo = MockProcessInfo()
    processInfo.mockedEnvironment = [
      "MOCKMARKS_IS_XCUI": String(true),
      "XCUI_MOCK_NAME": "I Don't Exist"
    ]
    MockMarks.setUp(processInfo: processInfo, bundle: .module)
    XCTAssert(MockMarks.queue.queuedResponses.isEmpty)
  }

  func test_setUp_shouldLoadJSON_whenPathProvided_andPathIsValid() {
    let processInfo = MockProcessInfo()
    processInfo.isRunningXCUI = true
    MockMarks.setUp(processInfo: processInfo, bundle: .module)
    XCTAssertFalse(MockMarks.queue.queuedResponses.isEmpty)
  }

  var url: URL {
    URL(string: "A")!
  }
}

class MockProcessInfo: ProcessInfo {
  var didQueryInitialMockJSON = false
  var isRunningXCUI = false
  var mockedEnvironment: [String: String]?

  override var environment: [String: String] {
    if let mockedEnvironment {
      return mockedEnvironment
    } else {
      return [
        "XCUI_MOCK_NAME": "MockMarksTests",
        "MOCKMARKS_IS_XCUI": String(isRunningXCUI)
      ]
    }
  }
}
