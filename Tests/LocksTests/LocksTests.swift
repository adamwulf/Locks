import XCTest
@testable import Locks

final class LocksTests: XCTestCase {
    func testSpinLock() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let lock = UnfairLock()
        lock.lock()
        lock.unlock()
        XCTAssertTrue(true)
    }

    func testRecursiveMutex() throws {
        let lock = RecursiveMutex()
        func foo(num: Int) {
            guard num > 0 else { return }
            lock.lock()
            XCTAssertTrue(lock.isLocked)
            foo(num: num - 1)
            lock.unlock()
        }

        XCTAssertFalse(lock.isLocked)
        foo(num: 10)
        XCTAssertFalse(lock.isLocked)
    }
}
