//
//  AtomicWrapper.swift
//  
//
//  Created by Adam Wulf on 9/27/21.
//

import Foundation

/// A thread-safe wrapper for a value
@propertyWrapper
public class Atomic<Value> {
    /// The internal lock used to ensure thread-safety
    private let lock = Mutex()
    /// The internal value of the wrapper
    private var value: Value

    /// The projected value of the wrapper
    public var projectedValue: Atomic<Value> {
        return self
    }

    /// Initializes the wrapper with the given value
    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    /// Performs a mutation on the wrapped value in a thread-safe manner
    /// - Parameter mutation: The mutation to perform on the wrapped value
    /// - Returns: The result of the mutation
    @discardableResult
    public func atomically<T>(_ mutation: (inout Value) -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return mutation(&value)
    }

    /// The wrapped value of the wrapper
    public var wrappedValue: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return value
        }
        set {
            lock.lock()
            value = newValue
            lock.unlock()
        }
    }
}
