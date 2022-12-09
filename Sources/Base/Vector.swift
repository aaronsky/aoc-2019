import Foundation

public struct Vector2: Equatable, Hashable {
    public var x: Int
    public var y: Int

    public static var zero: Self {
        .init()
    }

    public static var unit: Self {
        .init(x: 1, y: 1)
    }

    public var magnitude: Self {
        .init(x: abs(x), y: abs(y))
    }

    public var isOrthogonal: Bool {
        x == 0 || y == 0
    }

    public var manhattanDistance: Int {
        Int(x.magnitude + y.magnitude)
    }

    public var unit: Self {
        .init(
            x: x == 0 ? x : x / Int(x.magnitude),
            y: y == 0 ? y : y / Int(y.magnitude)
        )
    }

    public init(
        x: Int = 0,
        y: Int = 0
    ) {
        self.x = x
        self.y = y
    }

    public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func * (_ lhs: Self, _ rhs: Int) -> Self {
        Self(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}

public struct Vector3: Equatable, Hashable {
    public var x: Int
    public var y: Int
    public var z: Int

    public static var zero: Self {
        .init()
    }

    public static var unit: Self {
        .init(x: 1, y: 1, z: 1)
    }

    public var magnitude: Self {
        .init(x: abs(x), y: abs(y), z: abs(z))
    }

    public var isOrthogonal: Bool {
        [x, y, z].count(where: { $0 == 0 }) <= 1
    }

    public var manhattanDistance: Int {
        Int(x.magnitude + y.magnitude + z.magnitude)
    }

    public var unit: Self {
        .init(
            x: x == 0 ? x : x / Int(x.magnitude),
            y: y == 0 ? y : y / Int(y.magnitude),
            z: z == 0 ? z : z / Int(z.magnitude)
        )
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

    public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    public static func - (_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    public static func * (_ lhs: Self, _ rhs: Int) -> Self {
        Self(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
}
