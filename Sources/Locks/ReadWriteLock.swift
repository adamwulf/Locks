//
//  File.swift
//  
//
//  Created by Adam Wulf on 1/21/22.
//

import Foundation

class ReadWriteLock {
    private var rwlock: pthread_rwlock_t = {
        var rwlock = pthread_rwlock_t()
        pthread_rwlock_init(&rwlock, nil)
        return rwlock
    }()

    public func writeLock() {
        pthread_rwlock_wrlock(&rwlock)
    }

    public func readLock() {
        pthread_rwlock_rdlock(&rwlock)
    }

    public func unlock() {
        pthread_rwlock_unlock(&rwlock)
    }
}
