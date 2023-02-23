import Foundation
import XCTest
import StubbieTestUtils

class StubbieSamplerUITests: StubbieUITestCase {

  func test_whenThis_thenThat() {
    launchApp(withStubsNamed: #function)
    XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 20))
  }
}
