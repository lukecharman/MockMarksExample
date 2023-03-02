import Foundation
import XCTest
import MockMarks_XCUI

class MockMarksExampleUITests: MockMarksUITestCase {

  func test_singleResponse() {
    XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
  }

  func test_singleStubbedResponse() {
    XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
    loadWordButton.tap()
    XCTAssert(self.app.staticTexts["STUBBED"].waitForNonExistence(timeout: 5))
  }

  func test_twoStubbedResponsesToTheSameEndpoint() {
    XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
    loadWordButton.tap()
    XCTAssert(self.app.staticTexts["STUBBED AGAIN"].waitForExistence(timeout: 5))
    loadWordButton.tap()
    XCTAssert(self.app.staticTexts["STUBBED AGAIN"].waitForNonExistence(timeout: 5))
  }

  func test_twoStubbedResponsesToTwoDifferentEndpoints() {
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

private extension XCUIElement {

  func waitForNonExistence(timeout: TimeInterval) -> Bool {
    let timeStart = Date().timeIntervalSince1970

    while (Date().timeIntervalSince1970 <= (timeStart + timeout)) {
      if !exists {
        return true
      }
    }

    return false
  }
}
