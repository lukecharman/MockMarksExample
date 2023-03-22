import MockMarks
import XCTest

open class MockMarksUITestCase: XCTestCase {

  public var app: XCUIApplication!

  public func setUp(path: String = #filePath, recording: Bool) {
    super.setUp()

    app = XCUIApplication()

    let url: URL
    if #available(iOS 16, *) {
      url = URL(string: path)!
        .deletingLastPathComponent()
        .appending(path: MockMarks.Constants.stubsFolder)
    } else {
      url = URL(string: path)!
        .deletingLastPathComponent()
        .appendingPathComponent(MockMarks.Constants.stubsFolder)
    }

    app.launchEnvironment[MockMarks.Constants.isXCUI] = String(true)

    if recording {
      app.launchEnvironment[MockMarks.Constants.isRecording] = String(true)
    }

    app.launchEnvironment[MockMarks.Constants.stubDirectory] = url.absoluteString
    app.launchEnvironment[MockMarks.Constants.stubFilename] = "\(stubName).json"

    app.launch()
  }
}

public extension MockMarksUITestCase {

  var stubName: String {
    name
      .split(separator: " ")
      .last!
      .replacingOccurrences(of: "]", with: "")
  }
}
