import Foundation
import XCTest
import StubbieTestUtils

class StubbieSamplerUITests: StubbieUITestCase {

  func test_mockedResponse_array() {
    launchApp(withStubsNamed: #function)
    XCTAssert(self.app.staticTexts["STUBBED"].waitForExistence(timeout: 5))
  }
}
