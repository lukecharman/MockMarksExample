import Foundation
import XCTest
@testable import Stubbie

final class StubbieLoaderTests: XCTestCase {

  private var loader: StubbieLoader!
  private var mockedBundle: MockBundle!

  override func setUp() {
    super.setUp()

    mockedBundle = MockBundle()
    loader = StubbieLoader()
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

  func test_loadJSON_shouldConvertValidJSONIntoResponses() {
    //
  }

  func test_loadJSON_shouldSkipInvalidJSON_whenBuildingResponses() {
    //
  }

  func test_loadJSON_shouldReturnEmptyArray_whenAllJSONIsInvalid() {
    //
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
