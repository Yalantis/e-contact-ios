//
//  Queue.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/30/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

struct Queue<T> {

    // MARK: Properties

    var top: T? {
        return queue.first
    }
    var isEmpty: Bool {
        return queue.isEmpty
    }
    private var queue = [T]()

    // MARK: Public methods

    mutating func deQueue() -> T? {
        if !queue.isEmpty {
            return queue.removeFirst()
        } else {
            return nil
        }
    }

    mutating func enQueue(element: T) {
        queue.append(element)
    }

}
