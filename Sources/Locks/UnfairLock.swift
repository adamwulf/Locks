//
//  File.swift
//  
//
//  Created by Adam Wulf on 1/21/22.
//

import Foundation

public class UnfairLock: NSLocking {
    private let unfairLock: os_unfair_lock_t
    private var locked = false

    // returns true if the lock is locked, false otherwise
    public var isLocked: Bool {
        if os_unfair_lock_trylock(unfairLock) {
            os_unfair_lock_unlock(unfairLock)
            // if we were able to lock with the try(), then it wasn't locked when this method was called
            return false
        }
        // if we can't lock with the try(), then it was already locked
        return true
    }

    public init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    public func lock() {
        os_unfair_lock_lock(unfairLock)
        locked = true
    }

    public func unlock() {
        locked = false
        os_unfair_lock_unlock(unfairLock)
    }

    deinit {
        assert(!locked, "deinitialization of a spinlock results in undefined behavior!")
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }
}
