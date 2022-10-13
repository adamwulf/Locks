//
//  File.swift
//  
//
//  Created by Adam Wulf on 8/6/22.
//

import Foundation

public extension NSLocking {
    @discardableResult
    func lockDuring<T>(block : () -> T) -> T {
        self.lock()
        defer { self.unlock() }
        return block()
    }
}
