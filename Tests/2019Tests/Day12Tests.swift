import Testing

@testable import Advent2019

@Test
func day12() async throws {
    let day = try await Year2019().day(for: 12)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 14907)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 467_081_194_429_464)
}
