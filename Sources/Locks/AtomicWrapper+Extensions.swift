//
//  File.swift
//  
//
//  Created by Adam Wulf on 8/31/22.
//

import Foundation

/// An extension of the Atomic wrapper for Int values
public extension Atomic where Value == Int {
    /// Increments the wrapped value by one
    /// - Returns: The new value of the wrapper
    func increment() -> Int {
        return atomically { val in
            val += 1
            return val
        }
    }

    /// Decrements the wrapped value by one
    /// - Returns: The new value of the wrapper
    func decrement() -> Int {
        return atomically { val in
            val -= 1
            return val
        }
    }
}

public extension Atomic where Value == Bool {
    /// - returns: `true` if the boolean was `false` and is now toggled to `true`, `false` otherwise
    func toggleToTrueIfFalse() -> Bool {
        var didToggle = false
        self.atomically { val in
            if !val {
                val = true
                didToggle = true
            }
        }
        return didToggle
    }
}
