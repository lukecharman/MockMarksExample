import Foundation
import XCTest
@testable import MockMarks

final class RecorderTests: XCTestCase {

  func test_shouldRecord_shouldReadFromProcessInfo_whenTrue() {
    let info = MockProcessInfo()
    info.mockedEnvironment = [MockMarks.Constants.isRecording: String(true)]
    XCTAssert(MockMarks.Recorder(processInfo: info).shouldRecord)
  }

  func test_shouldRecord_shouldReadFromProcessInfo_whenFalse() {
    let info = MockProcessInfo()
    info.mockedEnvironment = [MockMarks.Constants.isRecording: String(false)]
    XCTAssertFalse(MockMarks.Recorder(processInfo: info).shouldRecord)
  }

  func test_shouldRecord_shouldDefaultToFalse_whenEnvironmentVariableIsNotSet() {
    let info = MockProcessInfo()
    info.mockedEnvironment = [:]
    XCTAssertFalse(MockMarks.Recorder(processInfo: info).shouldRecord)
  }

  func test_record_shouldInsertNewRecording() {
    let recorder = MockMarks.Recorder()
    recorder.record(url: URL(string: "A")!, data: nil, response: nil, error: nil)
    XCTAssertFalse(recorder.recordings.isEmpty)
  }

  func test_record_shouldInsertMultipleRecordings() {
    let recorder = MockMarks.Recorder()
    recorder.record(url: URL(string: "A")!, data: nil, response: nil, error: nil)
    recorder.record(url: URL(string: "A")!, data: nil, response: nil, error: nil)
    recorder.record(url: URL(string: "A")!, data: nil, response: nil, error: nil)
    XCTAssertEqual(recorder.recordings.count, 3)
  }

  func test_record_shouldRecordValidMockMark() {
    let recorder = MockMarks.Recorder()
    let url = URL(string: "A")!
    let data = try! JSONSerialization.data(withJSONObject: ["A": "B"])
    let response = HTTPURLResponse(url: url, statusCode: 123, httpVersion: nil, headerFields: nil)

    recorder.record(url: url, data: data, response: response, error: TestError.generic)

    guard let recording = recorder.recordings.first else {
      return XCTFail(#function)
    }

    XCTAssertEqual(recording["url"] as! String, url.absoluteString)

    guard let mock = recording["mock"] as? [String: Any] else {
      return XCTFail(#function)
    }

    XCTAssertEqual(mock["json"] as! [String: String], ["A": "B"])
    XCTAssertEqual(mock["responseCode"] as! Int, 123)
  }

  // TODO: Test writeRecordings here.
}
