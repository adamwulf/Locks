//
//  Mutex.swift
//
//
//  Created by Adam Wulf on 1/11/22.
//

import Foundation

public class Mutex: NSLocking {
    private var mutex: pthread_mutex_t = {
        var mutex = pthread_mutex_t()
        let err = pthread_mutex_init(&mutex, nil)
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
        return mutex
    }()

    public init() {
        // noop
    }

    public var name: String?

    public func `try`() -> Bool {
        if pthread_mutex_trylock(&mutex) == 0 {
            return true
        }
        return false
    }

    public func lock() {
        let ret = pthread_mutex_lock(&mutex)
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

    public func unlock() {
        let ret = pthread_mutex_unlock(&mutex)
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

    deinit {
        assert(pthread_mutex_trylock(&self.mutex) == 0 && pthread_mutex_unlock(&self.mutex) == 0,
               "deinitialization of a locked mutex results in undefined behavior!")
        pthread_mutex_destroy(&self.mutex)
    }
}
