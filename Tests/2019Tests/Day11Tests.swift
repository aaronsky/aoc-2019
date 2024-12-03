import Testing

@testable import Advent2019

@Test
func day11() async throws {
    let day = try await Year2019().day(for: 11)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 2211)
    let partTwo = await day.partTwo()
    #expect(partTwo == "EFCKUEGC")
}
