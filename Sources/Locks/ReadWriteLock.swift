//
//  File.swift
//  
//
//  Created by Adam Wulf on 1/21/22.
//

import Foundation

class ReadWriteLock {
    private let rwlock: UnsafeMutablePointer<pthread_rwlock_t>

    public init() {
        rwlock = UnsafeMutablePointer<pthread_rwlock_t>.allocate(capacity: 1)
        pthread_rwlock_init(rwlock, nil)
    }

    deinit {
        rwlock.deallocate()
    }

    public func writeLock() {
        pthread_rwlock_wrlock(rwlock)
    }

    public func readLock() {
        pthread_rwlock_rdlock(rwlock)
    }

    public func unlock() {
        pthread_rwlock_unlock(rwlock)
    }
}
