//
//  File.swift
//  
//
//  Created by Adam Wulf on 8/31/22.
//

import Foundation

public extension Atomic where Value == Int {
    func increment() -> Int {
        return atomically { val in
            val += 1
            return val
        }
    }
    func decrement() -> Int {
        return atomically { val in
            val -= 1
            return val
        }
    }
}
