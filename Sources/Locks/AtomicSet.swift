//
//  AtomicSet.swift
//  
//
//  Created by Adam Wulf on 4/18/22.
//

import Foundation

/// A thread-safe set that can be used to store elements
@frozen public struct AtomicSet<Element> where Element: Hashable {
    /// The internal lock used to ensure thread-safety
    private let lock = Mutex()
    /// The internal contents of the set
    private var contents = Set<Element>()

    /// The number of elements in the set
    public var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return contents.count
    }

    /// Initializes an empty set
    public init() {
        // noop
    }

    /// Inserts a new element into the set
    public mutating func insert(_ member: Element) {
        lock.lock()
        defer { lock.unlock() }
        contents.insert(member)
    }

    /// Forms a union of the set and the given sequence
    public mutating func formUnion<S>(_ other: S) where Element == S.Element, S: Sequence {
        lock.lock()
        defer { lock.unlock() }
        contents.formUnion(other)
    }

    /// Removes an element from the set
    public mutating func remove(_ member: Element) {
        lock.lock()
        defer { lock.unlock() }
        contents.remove(member)
    }

    /// Subtracts the given sequence from the set
    public mutating func subtract<S>(_ other: S) where Element == S.Element, S: Sequence {
        lock.lock()
        defer { lock.unlock() }
        contents.subtract(other)
    }

    /// Removes all elements from the set
    public mutating func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        contents.removeAll()
    }

    /// Checks if the set contains the given element
    public func contains(_ member: Element) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return contents.contains(member)
    }

    /// Checks if the set contains an element that satisfies the given predicate
    public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return try contents.contains(where: predicate)
    }
}
