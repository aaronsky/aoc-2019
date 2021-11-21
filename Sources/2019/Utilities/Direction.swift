//
//  Direction.swift
//  
//
//  Created by Aaron Sky on 11/20/21.
//

import Base

enum Direction {
    case up
    case down
    case left
    case right
}

extension Point2 {
    mutating func move(direction: Direction) {
        switch direction {
        case .up:
            self.y += 1
        case .down:
            self.y -= 1
        case .left:
            self.x -= 1
        case .right:
            self.x += 1
        }
    }
}
