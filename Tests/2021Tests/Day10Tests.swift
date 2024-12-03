import Testing

@testable import Advent2021

@Test
func day10() async throws {
    let day = try await Year2021().day(for: 10)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 166191)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 1_152_088_313)
}
