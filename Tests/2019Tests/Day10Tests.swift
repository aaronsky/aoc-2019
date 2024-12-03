import Testing

@testable import Advent2019

@Test
func day10() async throws {
    let day = try await Year2019().day(for: 10)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 280)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 706)
}
