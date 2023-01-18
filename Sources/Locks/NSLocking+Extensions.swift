//
//  NSLocking+Extensions.swift
//  
//
//  Created by Adam Wulf on 8/6/22.
//

import Foundation

/// An extension to NSLocking that adds a convenience method for locking during a block
public extension NSLocking {
    /// Executes the given block while the lock is held
    /// - Parameter block: The block to execute while the lock is held
    /// - Returns: The return value of the block
    @discardableResult
    func lockDuring<T>(block : () -> T) -> T {
        self.lock()
        defer { self.unlock() }
        return block()
    }
}
