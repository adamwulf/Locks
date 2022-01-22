import XCTest
@testable import Locks

final class LocksTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let lock = SpinLock()
        lock.lock()
        lock.unlock()
        XCTAssertTrue(true)
    }
}
