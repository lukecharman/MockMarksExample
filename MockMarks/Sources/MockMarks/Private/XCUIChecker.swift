import Foundation

enum XCUIChecker {
  static var isRunning = ProcessInfo.processInfo.environment["XCUI_IS_RUNNING"]
}
