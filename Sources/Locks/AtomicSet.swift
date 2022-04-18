//
//  File.swift
//  
//
//  Created by Adam Wulf on 4/18/22.
//

import Foundation

@frozen public struct AtomicSet<Element> where Element: Hashable {

    private let lock = Mutex()
    private var contents = Set<Element>()

    public var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return contents.count
    }

    public init() {
        // noop
    }

    public mutating func insert(_ member: Element) {
        lock.lock()
        defer { lock.unlock() }
        contents.insert(member)
    }

    public mutating func remove(_ member: Element) {
        lock.lock()
        defer { lock.unlock() }
        contents.remove(member)
    }

    public mutating func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        contents.removeAll()
    }

    public func contains(_ member: Element) -> Bool {
        return contents.contains(member)
    }

    public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try contents.contains(where: predicate)
    }
}
