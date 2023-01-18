//
//  Mutex.swift
//
//
//  Created by Adam Wulf on 1/11/22.
//

import Foundation

/// A thread-safe lock
public class Mutex: NSLocking {
    /// The internal mutex used to ensure thread-safety
    private let mutex: UnsafeMutablePointer<pthread_mutex_t>

    /// Returns true if the lock is locked, false otherwise
    public var isLocked: Bool {
        if pthread_mutex_trylock(mutex) == 0 {
            _ = pthread_mutex_unlock(mutex)
            // if we were able to lock with the try(), then it wasn't locked when this method was called
            return false
        }
        // if we can't lock with the try(), then it was already locked
        return true
    }

    /// Initializes the mutex
    public init() {
        mutex = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: 1)
        let err = pthread_mutex_init(mutex, nil)
        switch err {
        case 0: // Success
            break
        case EAGAIN:
            fatalError("Could not create mutex: EAGAIN (The system temporarily lacks the resources to create another mutex.)")
        case EINVAL:
            fatalError("Could not create mutex: invalid attributes")
        case ENOMEM:
            fatalError("Could not create mutex: no memory")
        default:
            fatalError("Could not create mutex, unspecified error \(err)")
        }
    }

    /// The name of the mutex. Setting this property is not threadsafe.
    public var name: String?

    /// Attempts to lock the mutex
    /// - Returns: True if the lock was successful, false otherwise
    public func `try`() -> Bool {
        if pthread_mutex_trylock(mutex) == 0 {
            return true
        }
        return false
    }

    /// Locks the mutex
    public func lock() {
        let ret = pthread_mutex_lock(mutex)
        switch ret {
        case 0: // Success
            break
        case EDEADLK:
            fatalError("Could not lock mutex: a deadlock would have occurred")
        case EINVAL:
            fatalError("Could not lock mutex: the mutex is invalid")
        default:
            fatalError("Could not lock mutex: unspecified error \(ret)")
        }
    }

    /// Unlocks the mutex
    public func unlock() {
        let ret = pthread_mutex_unlock(mutex)
        switch ret {
        case 0: // Success
            break
        case EPERM:
            fatalError("Could not unlock mutex: thread does not hold this mutex")
        case EINVAL:
            fatalError("Could not unlock mutex: the mutex is invalid")
        default:
            fatalError("Could not unlock mutex: unspecified error \(ret)")
        }
    }

    /// Deinitializes the mutex
    deinit {
        assert(pthread_mutex_trylock(mutex) == 0 && pthread_mutex_unlock(mutex) == 0,
               "deinitialization of a locked mutex results in undefined behavior!")
        pthread_mutex_destroy(mutex)
        mutex.deallocate()
    }
}
