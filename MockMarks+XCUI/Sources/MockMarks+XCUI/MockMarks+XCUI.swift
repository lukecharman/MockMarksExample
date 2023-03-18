import XCTest

open class MockMarksUITestCase: XCTestCase {

  public var app: XCUIApplication!
  public var filePath: String?

  override open func setUp() {
    super.setUp()

    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment["XCUI_IS_RUNNING"] = String(true)

    launchApp(withStubsNamed: stubName, filePath: filePath)
  }

  override public func tearDown() {
    app = nil

    super.tearDown()
  }

  public func launchApp(
    withStubsNamed name: String? = nil,
    filePath: String?
  ) {
    guard let name, let filePath else {
      return app.launch()
    }

    app.launchEnvironment["XCUI_INITIAL_MOCK_JSON"] = name

    let fileUrl = URL(fileURLWithPath: "\(filePath)", isDirectory: false)
    var mockDirectoryUrl = fileUrl.deletingLastPathComponent().appendingPathComponent("__MockMarks__")
    try! FileManager.default.createDirectory(at: mockDirectoryUrl, withIntermediateDirectories: true)
    mockDirectoryUrl = URL(string: mockDirectoryUrl.absoluteString.appending("\(name).json"))!

    app.launchEnvironment["XCUI_RECORDING_TEST_NAME"] = name

    app.launch()
  }
}

private extension MockMarksUITestCase {

  var stubName: String {
    name
      .split(separator: " ")
      .last!
      .replacingOccurrences(of: "]", with: "")
  }
}
