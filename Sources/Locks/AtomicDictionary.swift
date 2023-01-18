//
//  AtomicDictionary.swift
//  
//
//  Created by Adam Wulf on 4/20/22.
//

import Foundation

/// A thread-safe dictionary that can be used to store key-value pairs
@frozen public struct AtomicDictionary<Key, Value>: ExpressibleByDictionaryLiteral where Key: Hashable {
    /// Initializes the dictionary with the given elements
    public init(dictionaryLiteral elements: (Key, Value)...) {
        for element in elements {
            contents[element.0] = element.1
        }
    }

    /// The internal lock used to ensure thread-safety
    private let lock = Mutex()
    /// The internal contents of the dictionary
    private var contents: [Key: Value] = [:]

    /// The number of elements in the dictionary
    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return contents.count
    }

    /// The element type of a dictionary: a tuple containing an individual
    /// key-value pair.
    public typealias Element = (key: Key, value: Value)

    /// Subscript access to the dictionary
    public subscript(key: Key) -> Value? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return contents[key]
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            contents[key] = newValue
        }
    }
}
