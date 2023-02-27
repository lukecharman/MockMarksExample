import XCTest

open class StubbieUITestCase: XCTestCase {

  public var app: XCUIApplication!

  override public func setUp() {
    super.setUp()

    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment["XCUI_IS_RUNNING"] = String(true)
  }

  override public func tearDown() {
    app = nil

    super.tearDown()
  }

  public func launchApp(withStubsNamed name: String? = nil) {
    if let name {
      app.launchEnvironment["XCUI_INITIAL_MOCK_JSON"] = name
    }

    app.launch()
  }
}

