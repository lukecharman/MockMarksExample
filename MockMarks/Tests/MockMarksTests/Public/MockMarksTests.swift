import Foundation
import XCTest
@testable import MockMarks

final class MockMarksTests: XCTestCase {

  override func setUp() {
    super.setUp()
    MockMarks.queue.queuedResponses.removeAll()
  }

  func test_isXCUI_shouldReferToProcessInfo_whenTrue() {
    let mockedProcessInfo = MockProcessInfo()
    mockedProcessInfo.mockedIsRunningXCUI = true
    XCTAssert(MockMarks.isXCUI(processInfo: mockedProcessInfo))
  }

  func test_isXCUI_shouldReferToProcessInfo_whenFalse() {
    let mockedProcessInfo = MockProcessInfo()
    mockedProcessInfo.mockedIsRunningXCUI = false
    XCTAssertFalse(MockMarks.isXCUI(processInfo: mockedProcessInfo))
  }

  func test_setUp_shouldNotLoadJSON_whenXCUIIsNotRunning() {
    let processInfo = MockProcessInfo()
    processInfo.mockedIsRunningXCUI = false
    MockMarks.setUp(processInfo: processInfo)
    XCTAssert(MockMarks.queue.queuedResponses.isEmpty)
  }

  func test_setUp_shouldNotLoadJSON_whenStubDirectoryIsNotSet() {
    let processInfo = MockProcessInfo()
    processInfo.mockedEnvironment = [
      MockMarks.Constants.isXCUI: String(true),
      MockMarks.Constants.stubFilename: "B"
    ]
    MockMarks.setUp(processInfo: processInfo)
    XCTAssert(MockMarks.queue.queuedResponses.isEmpty)
  }

  func test_setUp_shouldNotQueue_whenStubFilenameIsNotSet() {
    let processInfo = MockProcessInfo()
    processInfo.mockedEnvironment = [
      MockMarks.Constants.isXCUI: String(true),
      MockMarks.Constants.stubDirectory: "B"
    ]
    MockMarks.setUp(processInfo: processInfo)
    XCTAssert(MockMarks.queue.queuedResponses.isEmpty)
  }

  func test_setUp_shouldLoadJSON_whenURLDoesContainJSON() {
    let url = Bundle.module.url(forResource: "LoaderTests", withExtension: "json")
    let dir = url?.deletingLastPathComponent()

    let processInfo = MockProcessInfo()
    processInfo.mockedEnvironment = [
      MockMarks.Constants.isXCUI: String(true),
      MockMarks.Constants.stubDirectory: dir!.absoluteString,
      MockMarks.Constants.stubFilename: "LoaderTests.json"
    ]

    MockMarks.setUp(processInfo: processInfo)
    XCTAssertFalse(MockMarks.queue.queuedResponses.isEmpty)
  }

  func test_dispatchNextQueuedResponse_shouldCallCompletion() {
    let data = try! JSONSerialization.data(withJSONObject: ["A": "B"])
    let response = MockMark.Response(data: data, urlResponse: nil, error: nil)
    let mockmark = MockMark(url: url, response: response)

    MockMarks.queue.queue(mockmark: mockmark)
    _ = MockMarks.dispatchNextQueuedResponse(for: url) { data, _, _ in
      let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
      XCTAssertEqual(json["A"] as! String, "B")
    }
  }
}

private extension MockMarksTests {

  var url: URL {
    URL(string: "A")!
  }
}
