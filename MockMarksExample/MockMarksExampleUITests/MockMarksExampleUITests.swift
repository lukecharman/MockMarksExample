import Foundation
import XCTest
import MockMarks_XCUI

class MockMarksExampleUITests: MockMarksUITestCase {

  func test_singleResponse() {
    launchApp(withStubsNamed: #function)
    XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
  }

  func test_singleStubbedResponse() {
    launchApp(withStubsNamed: #function)
    XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
    loadWordButton.tap()
    XCTAssert(self.app.staticTexts["STUBBED"].waitForNonExistence(timeout: 5))
  }

  func test_twoStubbedResponsesToTheSameEndpoint() {
    launchApp(withStubsNamed: #function)
    XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
    loadWordButton.tap()
    XCTAssert(self.app.staticTexts["STUBBED AGAIN"].waitForExistence(timeout: 5))
    loadWordButton.tap()
    XCTAssert(self.app.staticTexts["STUBBED AGAIN"].waitForNonExistence(timeout: 5))
  }

  func test_twoStubbedResponsesToTwoDifferentEndpoints() {
    launchApp(withStubsNamed: #function)
    XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
    loadWordButton.tap()
    XCTAssert(self.app.staticTexts["STUBBED"].waitForNonExistence(timeout: 5))
    loadLanguageButton.tap()
    XCTAssert(self.app.staticTexts["STUBBED TOO"].waitForNonExistence(timeout: 5))
  }
}

private extension MockMarksExampleUITests {

  var loadWordButton: XCUIElement {
    app.buttons["Load_Word_Button"]
  }

  var loadLanguageButton: XCUIElement {
    app.buttons["Load_Language_Button"]
  }
}