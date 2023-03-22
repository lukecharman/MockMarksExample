import XCTest
@testable import MockMarks

open class MockMarksUITestCase: XCTestCase {

  public var app: XCUIApplication!

  public func setUp(path: String = #filePath, recording: Bool) {
    super.setUp()

    app = XCUIApplication()

    var url = URL(string: path)!.deletingLastPathComponent()
    url.safeAppend(path: MockMarks.Constants.stubsFolder)

    app.launchEnvironment[MockMarks.Constants.isRecording] = String(recording)
    app.launchEnvironment[MockMarks.Constants.isXCUI] = String(true)
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
