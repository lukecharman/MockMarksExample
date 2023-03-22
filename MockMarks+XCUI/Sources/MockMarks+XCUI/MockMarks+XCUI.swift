import XCTest

open class MockMarksUITestCase: XCTestCase {

  public var app: XCUIApplication!

  public func setUp(path: String = #filePath, recording: Bool) {
    super.setUp()

    app = XCUIApplication()

    let url: URL
    if #available(iOS 16, *) {
      url = URL(string: path)!
        .deletingLastPathComponent()
        .appending(path: "__Stubs__")
    } else {
      url = URL(string: "A")!
    }

    app.launchEnvironment["MOCKMARKS_IS_XCUI"] = String(true)

    if recording {
      app.launchEnvironment["MOCKMARKS_IS_RECORDING"] = String(true)
    }

    app.launchEnvironment["MOCKMARKS_STUB_DIRECTORY"] = url.absoluteString
    app.launchEnvironment["MOCKMARKS_STUB_FILENAME"] = "\(stubName).json"

    app.launch()
  }
}

public extension MockMarksUITestCase {

  var stubName: String {
    name
      .split(separator: " ")
      .last!
      .replacingOccurrences(of: "]", with: "")
  }
}
