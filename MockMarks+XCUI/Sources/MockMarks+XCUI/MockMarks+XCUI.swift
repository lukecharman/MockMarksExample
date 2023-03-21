import XCTest

open class MockMarksUITestCase: XCTestCase {

  public var app: XCUIApplication!

  open override func setUp() {
    super.setUp()

    app = XCUIApplication()

    app.launchEnvironment["XCUI_IS_RUNNING"] = String(true)
    app.launchEnvironment["XCUI_MOCK_NAME"] = stubName
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
