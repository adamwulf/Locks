//
//  File.swift
//  
//
//  Created by Adam Wulf on 1/21/22.
//

import Foundation

@available(macOS 10.12, *)
public class SpinLock: NSLocking {
    private var unfairLock = os_unfair_lock_s()
    private var locked = false

    public func lock() {
        os_unfair_lock_lock(&unfairLock)
        locked = true
    }

    public func unlock() {
        locked = false
        os_unfair_lock_unlock(&unfairLock)
    }

    deinit {
        assert(!locked, "deinitialization of a spinlock results in undefined behavior!")
    }
}
