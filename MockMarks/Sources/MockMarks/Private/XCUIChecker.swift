import Foundation

/// Simple internal structure to wrap checking launch environment variables.
enum XCUIChecker {
  /// Whether XCUI tests are running or not.
  static var isRunning = ProcessInfo.processInfo.environment[MockMarks.Constants.isXCUI]
}
