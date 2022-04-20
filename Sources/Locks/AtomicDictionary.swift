//
//  AtomicDictionary.swift
//  
//
//  Created by Adam Wulf on 4/20/22.
//

import Foundation

@frozen public struct AtomicDictionary<Key, Value>: ExpressibleByDictionaryLiteral where Key: Hashable {

    public init(dictionaryLiteral elements: (Key, Value)...) {
        for element in elements {
            contents[element.0] = element.1
        }
    }

    private let lock = Mutex()
    private var contents: [Key: Value] = [:]

    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return contents.count
    }

    /// The element type of a dictionary: a tuple containing an individual
    /// key-value pair.
    public typealias Element = (key: Key, value: Value)

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
