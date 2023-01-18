/*===============================================================================================================================================================================*
 *     PROJECT: ReadWriteLock
 *    FILENAME: ThreadLocal.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 1/3/22
 *
 * Copyright © 2022. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this
 * permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 * AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *===============================================================================================================================================================================*/

import Foundation
import CoreFoundation
#if canImport(Darwin)
    import Darwin
#elseif canImport(Glibc)
    import Glibc
#elseif canImport(WinSDK)
    import WinSDK
#endif

/*==============================================================================================================*/
/// Thread Local Property Wrapper. A property marked with this wrapper will reserve storage for each thread so
/// that the values gotten and set will only be seen by that thread.
///
/// NOTE: You should use caution with DispatchQueues. DispatchQueues reuse threads. This means that multiple items
/// put onto a dispatch queue may be able see and manipulate data from another item on the queue.
///
@propertyWrapper
public struct ThreadLocal<T> {
    /// The initial value of the property.
    @usableFromInline let initialValue: T
    /// A unique key used to store the value in the thread dictionary.
    @usableFromInline let key: String = UUID().uuidString

    /// The wrapped value of the property.
    @inlinable public var wrappedValue: T {
        get {
            if let v = Thread.current.threadDictionary[key] as? T {
                return v
            }
            Thread.current.threadDictionary[key] = initialValue
            return initialValue
        }
        set {
            Thread.current.threadDictionary[key] = newValue
        }
    }

    /// Initializes the property wrapper with the given initial value.
    @inlinable public init(wrappedValue: T) {
        initialValue = wrappedValue
    }
}
