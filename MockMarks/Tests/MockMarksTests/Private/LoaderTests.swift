import Foundation
import XCTest
@testable import MockMarks

final class LoaderTests: XCTestCase {

  private var loader: MockMarks.Loader!
  private var mockedBundle: MockBundle!

  override func setUp() {
    super.setUp()

    mockedBundle = MockBundle()
    loader = MockMarks.Loader()
  }

  override func tearDown() {
    loader = nil
    mockedBundle = nil

    super.tearDown()
  }

  func test_loadJSON_shouldReturnNil_whenFileNotFoundInBundle() {
    XCTAssertNil(loader.loadJSON(named: "NOPE", in: mockedBundle))
  }

  func test_loadJSON_shouldReturnNil_whenURLContainsNonJSONData() {
    mockedBundle.stubbedURLForResource = URL(string: "NOPE")!
    XCTAssertNil(loader.loadJSON(named: "NOPE", in: mockedBundle))
  }

  func test_loadJSON_shouldReturnParsedData() {
    let result = loader.loadJSON(named: "LoaderTests", in: .module)
    XCTAssertEqual(result![0].url.absoluteString, "https://testing-some-json")
    XCTAssertEqual((result![0].stub as! [String])[0], "STUBBED OR WHATEVER")
  }

  func test_loadJSON_shouldReturnNil_whenDataCannotBeFound() {
    XCTAssertNil(loader.loadJSON(named: "BadJSONTests", in: .module))
  }

  func test_loadJSONData_shouldParseDataCorrectly() {
    let data = loader.loadJSONData(from: Bundle.module, named: "LoaderTests")
    XCTAssertNotNil(data)

    let json = try! JSONSerialization.jsonObject(with: data!) as! [[AnyHashable: Any]]
    XCTAssertEqual(json[0]["url"] as! String, "https://testing-some-json")
    XCTAssertEqual((json[0]["stub"] as! [String])[0], "STUBBED OR WHATEVER")
  }

  func test_loadJSONFromData_shouldParseJSONArrayOfDictsCorrectly() {
    let data = try! JSONSerialization.data(withJSONObject: goodJSON)
    let result = loader.loadJSON(from: data)

    guard let result else { return XCTFail(#function) }

    let firstURL = (result[0]["url"] as! String)
    let secondURL = (goodJSON[0]["url"] as! String)
    XCTAssertEqual(firstURL, secondURL)

    let firstStub = (result[0]["stub"] as! [String: String])
    let secondStub = (goodJSON[0]["stub"] as! [String: String])
    XCTAssertEqual(firstStub, secondStub)

    let thirdURL = (result[1]["url"] as! String)
    let fourthURL = (goodJSON[1]["url"] as! String)
    XCTAssertEqual(thirdURL, fourthURL)

    let thirdStub = (result[1]["stub"] as! [String: String])
    let fourthStub = (goodJSON[1]["stub"] as! [String: String])
    XCTAssertEqual(thirdStub, fourthStub)
  }

  func test_parseStubs_shouldParseValidStubsCorrectly() {
    let result = loader.parseStubs(from: goodJSON)

    XCTAssertEqual(result[0].url.absoluteString, "https://test.com")
    XCTAssertEqual(result[1].url.absoluteString, "https://again.com")
    XCTAssertEqual(result[0].stub as! [String: String], ["A": "B"])
    XCTAssertEqual(result[1].stub as! [String: String], ["C": "D"])
  }

  func test_parseStubs_shouldIgnoreInvalidStubs() {
    let result = loader.parseStubs(from: badJSON)

    XCTAssertEqual(result[0].url.absoluteString, "https://test.com")
    XCTAssertEqual(result[0].stub as! [String: String], ["A": "B"])
    XCTAssertEqual(result.count, 1)
  }

  var goodJSON: [[AnyHashable: Any]] {
    [
      [
        "url": "https://test.com",
        "stub": ["A": "B"]
      ], [
        "url": "https://again.com",
        "stub": ["C": "D"]
      ]
    ]
  }

  var badJSON: [[AnyHashable: Any]] {
    [
      [
        "url": "https://test.com",
        "stub": ["A": "B"]
      ], [
        "urllo": "https://again.com",
        "stubble": ["C": "D"]
      ]
    ]
  }
}

private class MockBundle: Bundle {

  var stubbedURLForResource: URL?

  override func url(forResource name: String?, withExtension ext: String?) -> URL? {
    stubbedURLForResource
  }
}

private extension Data {

  static func random(length: Int) throws -> Data {
    Data((0 ..< length).map { _ in UInt8.random(in: UInt8.min ... UInt8.max) })
  }
}
