import Foundation
import XCTest
@testable import MockMarks

final class MockMarksTests: XCTestCase {

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
    try! MockMarks.queue.queueValidResponse(with: ["A": "B"], from: url)
    _ = MockMarks.dispatchNextQueuedResponse(for: url) { data, _, _ in
      let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [AnyHashable: Any]
      XCTAssertEqual(json["A"] as! String, "B")
    }
  }

  var url: URL {
    URL(string: "A")!
  }
}
