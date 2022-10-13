//
//  AtomicWrapper.swift
//  Muse
//
//  Created by Adam Wulf on 9/27/21.
//  Copyright © 2021 Muse Software, Inc. All rights reserved.
//

import Foundation

@propertyWrapper
public class Atomic<Value> {
    private let lock = Mutex()
    private var value: Value

    public var projectedValue: Atomic<Value> {
        return self
    }

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    @discardableResult
    public func atomically<T>(_ mutation: (inout Value) -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return mutation(&value)
    }

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
