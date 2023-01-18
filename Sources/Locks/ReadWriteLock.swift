//
//  File.swift
//  
//
//  Created by Adam Wulf on 1/21/22.
//

import Foundation

/// A thread-safe read-write lock
public class ReadWriteLock {
    /// The internal read-write lock used to ensure thread-safety
    private let rwlock: UnsafeMutablePointer<pthread_rwlock_t>

    /// Initializes the read-write lock
    public init() {
        rwlock = UnsafeMutablePointer<pthread_rwlock_t>.allocate(capacity: 1)
        let err = pthread_rwlock_init(rwlock, nil)
        switch err {
        case 0: // Success
            break
        case EAGAIN:
            fatalError("Could not create read-write lock: EAGAIN (The system temporarily lacks the resources to create another read-write lock.)")
        case EINVAL:
            fatalError("Could not create read-write lock: invalid attributes")
        case ENOMEM:
            fatalError("Could not create read-write lock: no memory")
        default:
            fatalError("Could not create read-write lock, unspecified error \(err)")
        }
    }

    /// The name of the read-write lock. Setting this property is not threadsafe.
    public var name: String?

    /// Locks the read-write lock for writing
    public func writeLock() {
        let ret = pthread_rwlock_wrlock(rwlock)
        switch ret {
        case 0: // Success
            break
        case EDEADLK:
            fatalError("Could not lock read-write lock: a deadlock would have occurred")
        case EINVAL:
            fatalError("Could not lock read-write lock: the read-write lock is invalid")
        default:
            fatalError("Could not lock read-write lock: unspecified error \(ret)")
        }
    }

    /// Locks the read-write lock for reading
    public func readLock() {
        let ret = pthread_rwlock_rdlock(rwlock)
        switch ret {
        case 0: // Success
            break
        case EDEADLK:
            fatalError("Could not lock read-write lock: a deadlock would have occurred")
        case EINVAL:
            fatalError("Could not lock read-write lock: the read-write lock is invalid")
        default:
            fatalError("Could not lock read-write lock: unspecified error \(ret)")
        }
    }

    /// Unlocks the read-write lock
    public func unlock() {
        let ret = pthread_rwlock_unlock(rwlock)
        switch ret {
        case 0: // Success
            break
        case EPERM:
            fatalError("Could not unlock read-write lock: thread does not hold this read-write lock")
        case EINVAL:
            fatalError("Could not unlock read-write lock: the read-write lock is invalid")
        default:
            fatalError("Could not unlock read-write lock: unspecified error \(ret)")
        }
    }

    /// Deinitializes the read-write lock
    deinit {
        assert(pthread_rwlock_trywrlock(rwlock) == 0 && pthread_rwlock_unlock(rwlock) == 0,
               "deinitialization of a locked read-write lock results in undefined behavior!")
        pthread_rwlock_destroy(rwlock)
        rwlock.deallocate()
    }
}
