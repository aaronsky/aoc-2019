//
//  Point.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Darwin

public struct Point2: Equatable, Hashable {
    public var x: Int
    public var y: Int

    public static var zero: Self {
        .init()
    }

    public var isNegative: Bool {
        x < 0 || y < 0
    }

    public init() {
        self.init(x: 0, y: 0)
    }

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public func polarAngle(to other: Self) -> Double {
        let xDiff = Double(other.x - self.x)
        let yDiff = Double(other.y - self.y)

        return atan2(yDiff, xDiff)
    }

    public func manhattanDistance(to other: Self) -> Int {
        abs(self.x - other.x) + abs(self.y - other.y)
    }

    public static func +(_ lhs: Self, _ rhs: Self) -> Self {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
