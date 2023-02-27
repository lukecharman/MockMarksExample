import Foundation
import XCTest
@testable import Stubbie

final class StubbieLoaderTests: XCTestCase {

  func test_loadJSON_shouldReturnNil_whenFileNotFoundInBundle() {
    XCTAssertNil(StubbieLoader.loadJSON(named: "NOTREAL"))
  }

  func test_loadJSON_shouldReturnNil_whenURLExistsButContainsNoData() {
    XCTAssertNil(StubbieLoader.loadJSON(named: "NOTREAL", in: MockBundle()))
  }

  func test_loadJSON_shouldReturnNil_whenURLContainsNonJSONData() {
    //
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

  override func url(forResource name: String?, withExtension ext: String?) -> URL? {
    URL(string: "NOTREAL")!
  }
}
