import Foundation

public struct Point2: Equatable, Hashable {
    public var x: Int
    public var y: Int

    public static var zero: Self {
        .init()
    }

    public var isNegative: Bool {
        x < 0 || y < 0
    }

    public init(
        x: Int = 0,
        y: Int = 0
    ) {
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

    public func window() -> [Self] {
        [
            Self(x: x - 1, y: y - 1),
            Self(x: x, y: y - 1),
            Self(x: x + 1, y: y - 1),
            Self(x: x - 1, y: y),
            self,
            Self(x: x + 1, y: y),
            Self(x: x - 1, y: y + 1),
            Self(x: x, y: y + 1),
            Self(x: x + 1, y: y + 1),
        ]
    }

    public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func += (_ lhs: inout Self, _ rhs: Self) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}

public struct Point3: Equatable, Hashable {
    public var x: Int
    public var y: Int
    public var z: Int

    public static var zero: Self {
        .init()
    }

    public init(
        x: Int = 0,
        y: Int = 0,
        z: Int = 0
    ) {
        self.x = x
        self.y = y
        self.z = z
    }

    public func manhattanDistance(to other: Self) -> Int {
        abs(self.x - other.x) + abs(self.y - other.y) + abs(self.z - other.z)
    }

    public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    public static func += (_ lhs: inout Self, _ rhs: Self) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }

    public static func - (_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    public static func -= (_ lhs: inout Self, _ rhs: Self) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }
}

public struct Size: Equatable, Hashable, Comparable {
    public var width: Int
    public var height: Int

    public init(
        width: Int,
        height: Int
    ) {
        self.width = width
        self.height = height
    }

    public static func < (lhs: Size, rhs: Size) -> Bool {
        lhs.width < rhs.width && lhs.height < rhs.height
    }
}
