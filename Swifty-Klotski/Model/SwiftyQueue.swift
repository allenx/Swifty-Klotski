//
//  SwiftyQueue.swift
//  Klotski
//
//  Created by Allen X on 11/20/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

public struct SwiftyQueue<T> {
    
    // 2
    fileprivate var list = LinkedList<T>()
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    // 3
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    // 4
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        
        list.remove(element)
        
        return element.value
    }
    
    // 5
    public func peek() -> T? {
        return list.first?.value
    }
}

// 1
extension SwiftyQueue: CustomStringConvertible {
    // 2
    public var description: String {
        // 3
        return list.description
    }
}
