import Foundation
import XCTest
import MockMarks
import MockMarks_XCUI

class MockMarksExampleUITests: MockMarksUITestCase {

  override func setUp() {
    super.setUp(recording: false)
  }

  func test_singleResponse() {
    XCTAssert(mockedText.waitForExistence(timeout: 1))
  }

  func test_singleMockedResponse() {
    XCTAssert(mockedText.waitForExistence(timeout: 1))
    loadWordButton.tap()
    XCTAssert(mockedText.waitForNonExistence(timeout: 1))
  }

  func test_twoMockedResponsesToTheSameEndpoint() {
    XCTAssert(mockedText.waitForExistence(timeout: 1))
    loadWordButton.tap()
    XCTAssert(mockedAgainText.waitForExistence(timeout: 1))
    loadWordButton.tap()
    XCTAssert(mockedAgainText.waitForNonExistence(timeout: 1))
  }

  func test_twoMockedResponsesToTwoDifferentEndpoints() {
    XCTAssert(mockedText.waitForExistence(timeout: 1))
    loadWordButton.tap()
    XCTAssert(mockedText.waitForNonExistence(timeout: 1))
    loadLanguageButton.tap()
    XCTAssert(mockedTooText.waitForNonExistence(timeout: 1))
  }
}

private extension MockMarksExampleUITests {

  var loadWordButton: XCUIElement {
    app.buttons["Load_Word_Button"]
  }

  var loadLanguageButton: XCUIElement {
    app.buttons["Load_Language_Button"]
  }

  var mockedText: XCUIElement {
    app.staticTexts["MOCKED"]
  }

  var mockedTooText: XCUIElement {
    app.staticTexts["MOCKED TOO"]
  }

  var mockedAgainText: XCUIElement {
    app.staticTexts["MOCKED AGAIN"]
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
