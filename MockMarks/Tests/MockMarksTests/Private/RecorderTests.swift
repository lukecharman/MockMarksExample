import Foundation
import XCTest
@testable import MockMarks

final class RecorderTests: XCTestCase {

  override func setUp() {
    super.setUp()
    MockMarks.recorder.recordings.removeAll()
  }

  func test_record_shouldInsertIntoRecordings() {
    writeSomething()
    XCTAssertEqual(MockMarks.recorder.recordings.count, 1)
    writeSomething()
    XCTAssertEqual(MockMarks.recorder.recordings.count, 2)
    writeSomething()
    XCTAssertEqual(MockMarks.recorder.recordings.count, 3)
  }
}

private extension RecorderTests {

  func writeSomething() {
    let processInfo = MockProcessInfo()
    processInfo.mockedEnvironment = [
      MockMarks.Constants.stubDirectory: "A",
      MockMarks.Constants.stubFilename: "B",
    ]

    MockMarks.recorder.record(
      url: URL(string: "https://a.b.c")!,
      data: nil,
      response: nil,
      error: nil,
      processInfo: processInfo
    )
  }
}
