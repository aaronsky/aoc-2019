import Testing

@testable import Advent2021

@Test
func day19() async throws {
    let day = try await Year2021().day(for: 19)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 353)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 10832)
}
