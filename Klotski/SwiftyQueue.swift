//
//  SwiftyQueue.swift
//  Klotski
//
//  Created by Allen X on 11/20/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

class _QueueItem<T> {
    let value: T!
    var next: _QueueItem?
    
    init(_ newValue: T?) {
        self.value = newValue
    }
}

public class SwiftyQueue<T> {
    typealias Element = T
    var _front: _QueueItem<Element>
    var _back: _QueueItem<Element>
    
    public init() {
        //Insert a dummy item which will disappear when an item is inserted
        _back = _QueueItem(nil)
        _front = _back
    }
    
    func enqueue(value: Element) {
        _back.next = _QueueItem(value)
        _back = _back.next!
    }
    
    func dequeue(value: Element) -> Element? {
        if let newHead = _front.next {
            _front = newHead
            return newHead.value
        } else {
            return nil
        }
    }
    
    func isEmpty() -> Bool {
        return _front === _back
    }
}
