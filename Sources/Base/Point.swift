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

public struct Size: Equatable, Hashable, Comparable {
    public var width: Int
    public var height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    public static func < (lhs: Size, rhs: Size) -> Bool {
        lhs.width < rhs.width && lhs.height < rhs.height
    }
}
