import Foundation

public protocol Year {
    static var year: Int { get }
    var days: [Int: Day.Type] { get }
    func day(for number: Int) async throws -> Day
}

public protocol Day {
    init(_ input: Input) throws
    func partOne() async -> String
    func partTwo() async -> String
}

public extension Day {
    func partOne() async -> String {
        fatalError("unimplemented \(#function)")
    }

    func partTwo() async -> String {
        fatalError("unimplemented \(#function)")
    }
}

public struct DayNotFoundError: Error {
    public var day: Int
    public var year: Int

    public init(day: Int, year: Int) {
        self.day = day
        self.year = year
    }
}
