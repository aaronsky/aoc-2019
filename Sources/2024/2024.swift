import Base
import Foundation

public struct Year2024: Year {
    public static let year = 2024

    public let days: [Int: Day.Type] = [
        1: Day1.self,
        2: Day2.self,
        3: Day3.self,
    ]

    public init() {}

    public func day(for number: Int) async throws -> Day {
        let input = try await Input(day: number, in: Bundle.module)
        guard let dayType = days[number] else {
            throw DayNotFoundError(day: number, year: Self.year)
        }
        return try dayType.init(input)
    }
}
