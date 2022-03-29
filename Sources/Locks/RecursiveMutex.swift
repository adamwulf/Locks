//
//  RecursiveMutex.swift
//  
//
//  Created by Adam Wulf on 1/21/22.
//

import Foundation

public class RecursiveMutex: NSLocking {
    private var lockCount = 0

    // returns true if the lock is locked and held by this thread, false otherwise
    public var isLocked: Bool {
        if pthread_mutex_trylock(mutex) == 0 {
            let locked = lockCount > 0
            _ = pthread_mutex_unlock(mutex)
            return locked
        }
        return false
    }

    private var mutex: UnsafeMutablePointer<pthread_mutex_t>

    public init() {
        mutex = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: 1)
        var attr: pthread_mutexattr_t = pthread_mutexattr_t()
        withUnsafeMutablePointer(to: &attr) { attr in
            pthread_mutexattr_init(attr)
            pthread_mutexattr_settype(attr, PTHREAD_MUTEX_RECURSIVE)
            let err = pthread_mutex_init(mutex, attr)
            pthread_mutexattr_destroy(attr)
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
    }

    public var name: String?

    public func `try`() -> Bool {
        if pthread_mutex_trylock(mutex) == 0 {
            lockCount += 1
            return true
        }
        return false
    }

    public func lock() {
        let ret = pthread_mutex_lock(mutex)
        switch ret {
        case 0:
            lockCount += 1
        case EDEADLK:
            fatalError("Could not lock mutex: a deadlock would have occurred")
        case EINVAL:
            fatalError("Could not lock mutex: the mutex is invalid")
        default:
            fatalError("Could not lock mutex: unspecified error \(ret)")
        }
    }

    public func unlock() {
        lockCount -= 1
        let ret = pthread_mutex_unlock(mutex)
        switch ret {
        case 0:
            break
        case EPERM:
            fatalError("Could not unlock mutex: thread does not hold this mutex")
        case EINVAL:
            fatalError("Could not unlock mutex: the mutex is invalid")
        default:
            fatalError("Could not unlock mutex: unspecified error \(ret)")
        }
    }

    deinit {
        assert(pthread_mutex_trylock(mutex) == 0 && pthread_mutex_unlock(mutex) == 0 && lockCount == 0,
               "deinitialization of a locked mutex results in undefined behavior!")
        pthread_mutex_destroy(mutex)
        mutex.deallocate()
    }
}
