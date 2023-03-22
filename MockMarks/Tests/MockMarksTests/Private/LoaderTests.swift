import Foundation
import XCTest
@testable import MockMarks

final class LoaderTests: XCTestCase {

  private var loader: MockMarks.Loader!

  override func setUp() {
    super.setUp()

    loader = MockMarks.Loader()
  }

  override func tearDown() {
    loader = nil

    super.tearDown()
  }

  func test_loadJSON_shouldReturnNil_whenFileNotFoundInBundle() {
    XCTAssertNil(loader.loadJSON(from: URL(string: "file:///Nope")!))
  }

//  func test_loadJSON_shouldReturnNil_whenURLContainsNonJSONData() {
//    mockedBundle.stubbedURLForResource = URL(string: "NOPE")!
//    XCTAssertNil(loader.loadJSON(named: "NOPE", in: mockedBundle))
//  }
//
//  func test_loadJSON_shouldReturnParsedData() {
//    let result = loader.loadJSON(named: "LoaderTests", in: .module)
//    XCTAssertEqual(result![0].url.absoluteString, "https://testing-some-json")
//    let expectedResult = try! JSONSerialization.data(withJSONObject: ["STUBBED OR WHATEVER"])
//    XCTAssertEqual(result![0].response.data!, expectedResult)
//  }
//
//  func test_loadJSON_shouldReturnNil_whenDataCannotBeFound() {
//    XCTAssertNil(loader.loadJSON(named: "BadJSONTests", in: .module))
//  }
//
//  func test_loadJSONData_shouldParseDataCorrectly() {
//    let data = loader.loadJSONData(named: "LoaderTests", in: .module)
//    XCTAssertNotNil(data)
//
//    let json = try! JSONSerialization.jsonObject(with: data!) as! [[AnyHashable: Any]]
//    XCTAssertEqual(json[0]["url"] as! String, "https://testing-some-json")
//    XCTAssertEqual(((json[0]["mock"] as! [AnyHashable: Any])["json"] as! [String])[0], "STUBBED OR WHATEVER")
//  }
//
//  func test_loadJSONFromData_shouldParseJSONArrayOfDictsCorrectly() {
//    let data = try! JSONSerialization.data(withJSONObject: goodJSON)
//    let result = loader.loadJSON(from: data)
//
//    guard let result else { return XCTFail(#function) }
//
//    let firstURL = (result[0]["url"] as! String)
//    let secondURL = (goodJSON[0]["url"] as! String)
//    XCTAssertEqual(firstURL, secondURL)
//
//    let firstStub = (result[0]["mock"] as! [AnyHashable: Any])
//    let secondStub = (goodJSON[0]["mock"] as! [AnyHashable: Any])
//    XCTAssertEqual(firstStub["json"] as! [String: String], secondStub["json"] as! [String: String])
//
//    let thirdURL = (result[1]["url"] as! String)
//    let fourthURL = (goodJSON[1]["url"] as! String)
//    XCTAssertEqual(thirdURL, fourthURL)
//
//    let thirdStub = (result[1]["mock"] as! [AnyHashable: Any])
//    let fourthStub = (goodJSON[1]["mock"] as! [AnyHashable: Any])
//    XCTAssertEqual(thirdStub["json"] as! [String: String], fourthStub["json"] as! [String: String])
//  }
//
//  func test_parseStubs_shouldParseValidStubsCorrectly() {
//    let result = loader.parseStubs(from: goodJSON)
//
//    XCTAssertEqual(result[0].url.absoluteString, "https://test.com")
//    XCTAssertEqual(result[1].url.absoluteString, "https://again.com")
//
//    let expectedResultA = try! JSONSerialization.data(withJSONObject: ["A": "B"])
//    XCTAssertEqual(result[0].response.data!, expectedResultA)
//
//    let expectedResultB = try! JSONSerialization.data(withJSONObject: ["C": "D"])
//    XCTAssertEqual(result[1].response.data!, expectedResultB)
//  }
//
//  func test_parseStubs_shouldIgnoreInvalidStubs() {
//    let result = loader.parseStubs(from: badJSON)
//
//    XCTAssertEqual(result[0].url.absoluteString, "https://test.com")
//    XCTAssertEqual(result[0].response.json as! [String: String], ["A": "B"])
//    XCTAssertEqual(result.count, 1)
//  }
//
//  func test_parseStubs_shouldIgnoreStubsWhereURLIsInvalid() {
//    let result = loader.parseStubs(from: badURLJSON)
//    XCTAssertEqual(result.count, 0)
//  }
//
//  func test_parseStubs_shouldIgnoreStubsWhereNoMockDataIsFound() {
//    let result = loader.parseStubs(from: noMockJSON)
//    XCTAssertEqual(result.count, 0)
//  }

  var goodJSON: [[AnyHashable: Any]] {
    [
      [
        "url": "https://test.com",
        "mock": [
          "json": ["A": "B"]
        ]
      ], [
        "url": "https://again.com",
        "mock": [
          "json": ["C": "D"]
        ]
      ]
    ]
  }

  var badJSON: [[AnyHashable: Any]] {
    [
      [
        "url": "https://test.com",
        "mock": [
          "json": ["A": "B"]
        ]
      ], [
        "urllo": "https://again.com",
        "mock": [
          "jsondle": ["C": "D"]
        ]
      ]
    ]
  }

  var badURLJSON: [[AnyHashable: Any]] {
    [
      [
        "url": "💥"
      ]
    ]
  }

  var noMockJSON: [[AnyHashable: Any]] {
    [
      [
        "url": "https://blah.blah"
      ]
    ]
  }
}

private extension Data {

  static func random(length: Int) throws -> Data {
    Data((0 ..< length).map { _ in UInt8.random(in: UInt8.min ... UInt8.max) })
  }
}
