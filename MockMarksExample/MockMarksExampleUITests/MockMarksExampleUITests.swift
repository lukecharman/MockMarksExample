import Foundation
import XCTest
import MockMarks
import MockMarks_XCUI

class MockMarksExampleUITests: MockMarksUITestCase {

  override func setUp() {
    super.setUp()

    let name = #file
    let url = URL(string: name)!
      .deletingLastPathComponent()
      .appending(path: "__Stubs__")

    MockMarks.setRecording(to: url)

    app.launchEnvironment["BOOP_RECORDING"] = String(true)
    app.launchEnvironment["BOOP_DIRECTORY"] = url.absoluteString
    app.launchEnvironment["BOOP_FILENAME"] = "\(stubName).json"

    app.launch()
  }

  func test_singleResponse() {
    XCTAssert(stubbedText.waitForExistence(timeout: 1))
  }

  func test_singleStubbedResponse() {
    XCTAssert(stubbedText.waitForExistence(timeout: 1))
    loadWordButton.tap()
    XCTAssert(stubbedText.waitForNonExistence(timeout: 1))
  }

  func test_twoStubbedResponsesToTheSameEndpoint() {
    XCTAssert(stubbedText.waitForExistence(timeout: 1))
    loadWordButton.tap()
    XCTAssert(stubbedAgainText.waitForExistence(timeout: 1))
    loadWordButton.tap()
    XCTAssert(stubbedAgainText.waitForNonExistence(timeout: 1))
  }

  func test_twoStubbedResponsesToTwoDifferentEndpoints() {
    XCTAssert(stubbedText.waitForExistence(timeout: 1))
    loadWordButton.tap()
    XCTAssert(stubbedText.waitForNonExistence(timeout: 1))
    loadLanguageButton.tap()
    XCTAssert(stubbedTooText.waitForNonExistence(timeout: 1))
  }
}

private extension MockMarksExampleUITests {

  var loadWordButton: XCUIElement {
    app.buttons["Load_Word_Button"]
  }

  var loadLanguageButton: XCUIElement {
    app.buttons["Load_Language_Button"]
  }

  var stubbedText: XCUIElement {
    app.staticTexts["STUBBED"]
  }

  var stubbedTooText: XCUIElement {
    app.staticTexts["STUBBED TOO"]
  }

  var stubbedAgainText: XCUIElement {
    app.staticTexts["STUBBED AGAIN"]
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
