import XCTest
@testable import MockMarks

open class MockMarksUITestCase: XCTestCase {

  public var app: XCUIApplication!

  public func setUp(path: String = #filePath, recording: Bool) {
    super.setUp()

    var url = URL(string: path)!.deletingLastPathComponent()
    url.safeAppend(path: MockMarks.Constants.mocksFolder)

    app = XCUIApplication()

    app.launchEnvironment[MockMarks.Constants.isRecording] = String(recording)
    app.launchEnvironment[MockMarks.Constants.isXCUI] = String(true)
    app.launchEnvironment[MockMarks.Constants.mockDirectory] = url.absoluteString
    app.launchEnvironment[MockMarks.Constants.mockFilename] = "\(mockName).json"

    app.launch()
  }
}

public extension MockMarksUITestCase {

  var mockName: String {
    name
      .split(separator: " ")
      .last!
      .replacingOccurrences(of: "]", with: "")
  }
}
