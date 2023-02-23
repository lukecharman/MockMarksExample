import Stubbie
import XCTest

open class StubbieUITestCase: XCTestCase {

  public var app: XCUIApplication!

  override public func setUp() {
    super.setUp()

    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment[Stubbie.K.isRunningXCUI] = String(true)
  }

  override public func tearDown() {
    app = nil

    super.tearDown()
  }

  public func launchApp(withStubsNamed name: String? = nil) {
    if let name {
      app.launchEnvironment[Stubbie.K.initialMockJSON] = name
    }

    app.launch()
  }
}

