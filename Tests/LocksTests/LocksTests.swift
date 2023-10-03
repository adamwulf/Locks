import XCTest
@testable import Locks

final class LocksTests: XCTestCase {
    func testUnfairLock() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let lock = UnfairLock()
        XCTAssertFalse(lock.isLocked)
        lock.lock()
        XCTAssertTrue(lock.isLocked)
        lock.unlock()
        XCTAssertFalse(lock.isLocked)
    }

    func testMutexLock() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let lock = Mutex()
        XCTAssertFalse(lock.isLocked)
        lock.lock()
        XCTAssertTrue(lock.isLocked)
        lock.unlock()
        XCTAssertFalse(lock.isLocked)
    }

    func testAtomicSet() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var set = AtomicSet<Int>()

        XCTAssertEqual(set.count, 0)
        set.insert(12)
        XCTAssertEqual(set.count, 1)
        XCTAssertTrue(set.contains(12))
        set.insert(12)
        XCTAssertEqual(set.count, 1)
        set.remove(12)
        XCTAssertEqual(set.count, 0)
    }

    func testAtomicDictionary() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var dict = AtomicDictionary<String, Int>()

        XCTAssertEqual(dict.count, 0)
        dict["foo"] = 12
        XCTAssertEqual(dict.count, 1)
        XCTAssertEqual(dict["foo"], 12)
        dict["foo"] = 12
        XCTAssertEqual(dict.count, 1)
        dict["foo"] = nil
        XCTAssertEqual(dict.count, 0)
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

    func testToggleBoolean() throws {
        @Atomic var someBool = false

        XCTAssertFalse(someBool)
        XCTAssertTrue($someBool.toggleToTrueIfFalse())
        XCTAssertTrue(someBool)
        XCTAssertFalse($someBool.toggleToTrueIfFalse())
        XCTAssertTrue(someBool)
    }
}
