import Foundation
import XCTest
@testable import Stubbie

final class StubbieURLSessionDataTaskTests: XCTestCase {

  func test_init_shouldStoreTask() {
    let task = URLSessionDataTask()
    let stubbieTask = StubbieURLSessionDataTask(stubbing: task, completionHandler: { _, _ ,_ in })
    XCTAssertIdentical(task, stubbieTask.task)
  }
}
