//
//  File.swift
//  
//
//  Created by Adam Wulf on 1/21/22.
//

import Foundation

/// UnfairLock is a class that implements the NSLocking protocol. It uses the os_unfair_lock_t
/// to provide a lock that is more performant than a traditional spinlock.
public class UnfairLock: NSLocking {
    /// The underlying os_unfair_lock_t used to provide the lock.
    private let unfairLock: os_unfair_lock_t
    /// A flag to indicate if the lock is currently locked.
    private var locked = false

    /// Returns true if the lock is locked, false otherwise.
    public var isLocked: Bool {
        if os_unfair_lock_trylock(unfairLock) {
            os_unfair_lock_unlock(unfairLock)
            // if we were able to lock with the try(), then it wasn't locked when this method was called
            return false
        }
        // if we can't lock with the try(), then it was already locked
        return true
    }

    /// Initializes the UnfairLock.
    public init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    /// Locks the UnfairLock.
    public func lock() {
        os_unfair_lock_lock(unfairLock)
        locked = true
    }

    /// Unlocks the UnfairLock.
    public func unlock() {
        locked = false
        os_unfair_lock_unlock(unfairLock)
    }

    /// Deinitializes the UnfairLock.
    deinit {
        assert(!locked, "deinitialization of a spinlock results in undefined behavior!")
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }
}
