import XCTest

extension XCUIElement {

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
